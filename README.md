# RStudio Server
[![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/909)

Singularity container running RStudio Server.

Example job script:
```
#!/bin/bash
#PBS -N jnb
#PBS -l nodes=1:ppn=1
#PBS -l mem=5gb
#PBS -l walltime=1:00:00
#PBS -j oe

# tunnel info
PORT=$(shuf -i8000-9999 -n1)

# rserver password
export RSTUDIO_PASSWORD=$(openssl rand -base64 15)

# print tunneling instructions
echo -e "
1. SSH tunnel from your workstation using the following command:
   
   ssh -L 8787:${HOSTNAME}:${PORT} ${USER}@$PBS_O_HOST
   
   and point your web browser to http://localhost:8787.

2. Log in to RStudio Server using the following credentials:
   user: ${USER}
   password: ${RSTUDIO_PASSWORD}
"

# load modules
module load RStudio/1.1.442

#start server
rstudio-server
```

## Start a Jupyter Notebook
1. Copy contents of jupyternb.pbs (example above) to a file in your home directory.

2. Open terminal on cluster login node and submit the job script:

```
$ qsub jupyternb.pbs
```

## Connect to Notebook
1. Check output file (*jobname*.o*JOBNUM*) for details.

Example output file: jnb.o152668
```
1. SSH tunnel from your workstation using the following command:

   ssh -L 9623:node01:9623 tester@loginnode

   and point your web browser to http://localhost:9623.

2. Copy/paste the token below when you connect for the first time.

[I 18:24:35.251 NotebookApp] Serving notebooks from local directory: /home/tester/jupyter-test
[I 18:24:35.251 NotebookApp] 0 active kernels
[I 18:24:35.251 NotebookApp] The Jupyter Notebook is running at:
[I 18:24:35.251 NotebookApp] http://node01:9623/?token=a2caff9717f5dcefc22c4c387fa0a02390d1ef71f0f3747d
[I 18:24:35.251 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 18:24:35.256 NotebookApp]

    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://node01:9623/?token=a2caff9717f5dcefc22c4c387fa0a02390d1ef71f0f3747d
```

2. Open second terminal and run tunneling command from the output file:
```
$ ssh -L 9454:node01:9454 tester@loginnode
```
3. Open a browser and enter the URL from the output file:
```
http://localhost:9454
```
4. Enter the token (long string after ?token=) from the output file.

You should now be connected to your Jupyter Notebook that is running on a cluster compute node. To close the notebook, select Logout. If you need to reconnect, repeat steps. If you're done with your Notebook, remember to stop the job with qdel.

