class stop():
    def stop_ec2(self, instance, client):
        self.instance = instance
        self.client = client

        client.stop_instance(
            DBInstanceIdentifier=instance,
        )
