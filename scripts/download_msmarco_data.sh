mkdir collections/msmarco-passage

time wget -nc https://msmarco.blob.core.windows.net/msmarcoranking/collectionandqueries.tar.gz -P collections/msmarco-passage

# Alternative mirror:
# wget https://www.dropbox.com/s/9f54jg2f71ray3b/collectionandqueries.tar.gz -P collections/msmarco-passage

# Checking md5sum
md5sum collections/msmarco-passage/collectionandqueries.tar.gz

time tar xvfz collections/msmarco-passage/collectionandqueries.tar.gz -C collections/msmarco-passage
