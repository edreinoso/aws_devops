class startRDS():
    def start_rds(self, instance, client):
        self.instance = instance
        self.client = client

        client.start_db_instance(
            DBInstanceIdentifier=instance,
        )
