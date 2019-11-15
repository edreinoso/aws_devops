class createTag():
    def create_tag(self, client, volume_id, key, value):
        self.client = client
        self.volume_id = volume_id
        self.key = key
        self. value = value
        
        client.create_tags(
            Resources=[volume_id],
            Tags=[
                {
                    'Key': key,
                    'Value': value
                },
            ]
        )