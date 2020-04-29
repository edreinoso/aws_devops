class createTag():
    def create_tag(self, client, eniId, ec2TagKey, ec2TagValue):
        self.client = client
        self.eniId = eniId
        self.ec2TagKey = ec2TagKey
        self.ec2TagValue = ec2TagValue

        client.create_tags(
            Resources=[
                eniId
            ],
            Tags=[
                {
                    'Key': ec2TagKey,
                    'Value': ec2TagValue,
                },
            ],
        )
