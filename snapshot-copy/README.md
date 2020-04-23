# Snapshot Copy Region

### Goal

Automate snapshot copy to a different region as a disaster recovery solution.

### Motivation


It is important to have a failover mechanism to restore snapshots in case there is a region outage (unlikely, but possible). Copying snapshots to another reigion is the best way of doing this. But, when there are thousands of snapshots, this can easily become an overhead. So that is why I decided to develop these four automation code that will take care of the copying snapshots to another region automatically.

### Directory structure

The code is dispersed in four different classes (each of them being their own separate function):
  - Snapshot tagging: this is extremelly helpful when having a very high number of snapshots. The function will give tags to certain snapshots with Key DR and Value Y

  - Snapshot copy: this is the function that would be in charge of copying over all snapshots. It is important to **only 5 snapshots** can be copied at a time.

  - Snapshot tag delete: this deletes the DR tag provided by the first function

  - Snapshot delete: this deletes snapshots that are older than a certain time