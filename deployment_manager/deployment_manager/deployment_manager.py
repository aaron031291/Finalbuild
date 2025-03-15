import logging
import time
from threading import Thread, Event

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(levelname)s] %(message)s')

class DeploymentManager:
    def __init__(self):
        self.deployments = {}
        self.environments = {}
        self.templates = {}
        self.auto_scaling_enabled = True
        self.shutdown_event = Event()

    def register_environment(self, name, config):
        self.environments[name] = config
        logging.info(f'Environment registered: {name}')

    def register_template(self, name, components):
        self.templates[name] = components
        logging.info(f'Template registered: {name}')

    def deploy(self, name, template_name, env_name, instances=1):
        if template_name not in self.templates or env_name not in self.environments:
            logging.error('Invalid template or environment.')
            return

        deployment_id = f"{name}-{int(time.time())}"
        self.deployments[deployment_id] = {
            'name': name,
            'template': self.templates[template_name],
            'environment': self.environments[env_name],
            'instances': instances,
            'status': 'deploying',
            'created': time.time()
        }
        logging.info(f'Starting deployment: {deployment_id}')
        Thread(target=self._simulate_deployment, args=(deployment_id,)).start()

    def _simulate_deployment(self, deployment_id):
        deployment = self.deployments[deployment_id]
        time.sleep(2)  # Simulate resource provisioning
        deployment['status'] = 'running'
        logging.info(f'Deployment successful: {deployment_id}')

    def auto_scale(self):
        while not self.shutdown_event.is_set():
            for deployment_id, deployment in self.deployments.items():
                current_instances = deployment['instances']
                utilization = self._get_simulated_utilization()

                if utilization > 75:
                    deployment['instances'] += 1
                    logging.info(f'Auto-scaled up {deployment_id} to {deployment["instances"]} instances.')
                elif utilization < 30 and current_instances > 1:
                    deployment['instances'] -= 1
                    logging.info(f'Auto-scaled down {deployment_id} to {deployment["instances"]} instances.')

            time.sleep(60)

    def health_check(self):
        while not self.shutdown_event.is_set():
            for deployment_id, deployment in self.deployments.items():
                status = 'healthy' if self._simulate_health() else 'unhealthy'
                logging.info(f'Health check for {deployment_id}: {status}')
                if status == 'unhealthy':
                    self._recover(deployment_id)
            time.sleep(30)

    def _recover(self, deployment_id):
        logging.warning(f'Recovering deployment: {deployment_id}')
        time.sleep(1)
        self.deployments[deployment_id]['status'] = 'running'
        logging.info(f'Recovery complete: {deployment_id}')

    def _get_simulated_utilization(self):
        from random import randint
        return randint(20, 90)

    def _simulate_health(self):
        from random import random
        return random() > 0.1

    def start(self):
        logging.info('Starting Deployment Manager...')
        Thread(target=self.auto_scale, daemon=True).start()
        Thread(target=self.health_check, daemon=True).start()

    def shutdown(self):
        logging.info('Shutting down Deployment Manager...')
        self.shutdown_event.set()


if __name__ == '__main__':
    manager = DeploymentManager()

    # Register environments and templates
    manager.register_environment('production', {'resources': {'cpu': 8, 'ram': 32}})
    manager.register_template('full', ['core', 'network', 'security', 'storage'])

    # Start manager
    manager.start()

    # Deploy example
    manager.deploy('edge-service', 'full', 'production', instances=2)

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        manager.shutdown()
