class start():
    def start_ec2(self, instance, client):
        self.instance = instance
        self.client = client

        client.start_instance(
            DBInstanceIdentifier=instance,
        )
