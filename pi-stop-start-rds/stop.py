class stopRDS():
    def stop_rds(self, instance, client):
        self.instance = instance
        self.client = client

        client.stop_db_instance(
            DBInstanceIdentifier=instance,
        )
