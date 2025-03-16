import os
import time
import requests
import json
from datetime import datetime
import digitalocean
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

class AutoScaler:
    def __init__(self):
        self.do_token = os.getenv('DIGITALOCEAN_TOKEN')
        self.slack_token = os.getenv('SLACK_TOKEN')
        self.manager = digitalocean.Manager(token=self.do_token)
        self.slack_client = WebClient(token=self.slack_token)
        
        # Configuration
        self.baseline_config = {
            'vcpu': 8,
            'ram': 32,
            'storage': 500,
            'thresholds': {
                'cpu': 75,
                'ram': 80,
                'disk': 85,
                'response_time': 2000  # ms
            },
            'cooldown_period': 300  # 5 minutes
        }
        
        self.last_scale_time = 0
        self.current_config = self.baseline_config.copy()

    def monitor_resources(self):
        """Collect system metrics from monitoring service"""
        return {
            'cpu': self.get_cpu_usage(),
            'ram': self.get_memory_usage(),
            'disk': self.get_disk_usage(),
            'response_time': self.get_avg_response_time()
        }

    def analyze_metrics(self, metrics):
        """Determine if scaling is needed"""
        needs_scale = False
        recommendations = []
        
        if metrics['cpu'] > self.current_config['thresholds']['cpu']:
            recommendations.append(f"CPU usage {metrics['cpu']}%")
        if metrics['ram'] > self.current_config['thresholds']['ram']:
            recommendations.append(f"RAM usage {metrics['ram']}%")
        if metrics['disk'] > self.current_config['thresholds']['disk']:
            recommendations.append(f"Disk usage {metrics['disk']}%")
        if metrics['response_time'] > self.current_config['thresholds']['response_time']:
            recommendations.append(f"Response time {metrics['response_time']}ms")
            
        return recommendations

    def calculate_scaling(self, recommendations):
        """Determine required scaling parameters"""
        scale_factor = 1.5 if len(recommendations) > 2 else 1.25
        return {
            'vcpu': min(64, int(self.current_config['vcpu'] * scale_factor)),
            'ram': min(128, int(self.current_config['ram'] * scale_factor)),
            'storage': min(2000, int(self.current_config['storage'] * scale_factor))
        }

    def send_notification(self, current_metrics, proposed_config):
        """Send scaling request to Slack"""
        message = {
            "text": "⚠️ *Scaling Recommendation Required*",
            "blocks": [
                {
                    "type": "section",
                    "text": {
                        "type": "mrkdwn",
                        "text": f"*System requires scaling*:\n{json.dumps(current_metrics, indent=2)}"
                    }
                },
                {
                    "type": "actions",
                    "elements": [
                        {
                            "type": "button",
                            "text": {"type": "plain_text", "text": "Approve"},
                            "style": "primary",
                            "value": "approve"
                        },
                        {
                            "type": "button",
                            "text": {"type": "plain_text", "text": "Modify"},
                            "value": "modify"
                        },
                        {
                            "type": "button",
                            "text": {"type": "plain_text", "text": "Deny"},
                            "style": "danger",
                            "value": "deny"
                        }
                    ]
                }
            ]
        }
        
        try:
            response = self.slack_client.chat_postMessage(
                channel="#infra-alerts",
                blocks=message['blocks']
            )
            return response['ts']  # Return message timestamp
        except SlackApiError as e:
            print(f"Slack error: {e.response['error']}")
            return None

    def scale_resources(self, new_config):
        """Execute scaling operation on DigitalOcean"""
        droplet = self.manager.get_droplet(os.getenv('DROPLET_ID'))
        
        # Check if droplet needs to be powered off for resize
        if droplet.status != 'off':
            droplet.shutdown()
            while droplet.status != 'off':
                time.sleep(5)
                droplet = self.manager.get_droplet(droplet.id)
        
        droplet.resize(new_config['vcpu'], new_config['ram'], new_config['storage'])
        droplet.power_on()
        
        self.current_config = new_config
        self.last_scale_time = time.time()
        self.log_operation("SCALE_UP", new_config)

    def scale_down_check(self):
        """Check if we can scale back to baseline"""
        if time.time() - self.last_scale_time > 86400:  # 24 hours
            metrics = self.monitor_resources()
            if all(v < (self.baseline_config['thresholds'][k] * 0.6) 
                   for k, v in metrics.items() if k != 'response_time'):
                self.scale_resources(self.baseline_config)
                self.send_notification(metrics, self.baseline_config)

    def log_operation(self, operation, config):
        """Record scaling operations"""
        log_entry = {
            "timestamp": datetime.utcnow().isoformat(),
            "operation": operation,
            "config": config,
            "cost_impact": self.calculate_cost_impact(config)
        }
        
        # Store in database or append to log file
        with open("scaling_logs.json", "a") as f:
            f.write(json.dumps(log_entry) + "\n")

    def calculate_cost_impact(self, new_config):
        """Estimate cost difference"""
        current_cost = (self.current_config['vcpu'] * 0.1 + 
                       self.current_config['ram'] * 0.05 + 
                       self.current_config['storage'] * 0.01)
        new_cost = (new_config['vcpu'] * 0.1 + 
                   new_config['ram'] * 0.05 + 
                   new_config['storage'] * 0.01)
        return new_cost - current_cost

    def run(self):
        """Main monitoring loop"""
        while True:
            if time.time() - self.last_scale_time > self.baseline_config['cooldown_period']:
                metrics = self.monitor_resources()
                recommendations = self.analyze_metrics(metrics)
                
                if recommendations:
                    proposed_config = self.calculate_scaling(recommendations)
                    message_ts = self.send_notification(metrics, proposed_config)
                    
                    # Wait for human response (implement response handling)
                    time.sleep(300)  # Wait 5 minutes for response
                    
                    # If approved (mock response handling)
                    if self.check_approval(message_ts):
                        self.scale_resources(proposed_config)
                
                self.scale_down_check()
            
            time.sleep(60)

if __name__ == "__main__":
    scaler = AutoScaler()
    scaler.run()