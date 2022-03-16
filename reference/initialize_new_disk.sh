# create a partition using fdisk
fdisk /dev/sdb

    # Commands:
    #     to create the partition: n, p, [enter], [enter]
    #     to give a type to the partition: t, 7 (don't select 86 or 87, those are for volume sets)
    #     if you want to make it bootable: a
    #     to see the changes: p
    #     to write the changes: w

# create a ntfs fileystem on /dev/sdx1:
mkfs.ntfs -f /dev/sdb1


