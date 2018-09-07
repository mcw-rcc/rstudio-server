# RStudio Server
[![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/1268)

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
SUBMIT_HOST=$(echo ${PBS_O_HOST%%.*}.rcc.mcw.edu)

# rserver password
export RSTUDIO_PASSWORD=$(openssl rand -base64 15)

# print tunneling instructions
echo -e "
1. SSH tunnel from your workstation using the following command:
   
   ssh -L 8787:${HOSTNAME}:${PORT} ${USER}@${SUBMIT_HOST}
   
   and point your web browser to http://localhost:8787.

2. Log in to RStudio Server using the following credentials:
   user: ${USER}
   password: ${RSTUDIO_PASSWORD}
"

# load modules
module load rstudio-server/1.1.456

#start server
rstudio-server
```

## Start an RStudio session
1. Copy contents of rserver.pbs (example above) to a file in your home directory.

2. Open terminal on cluster login node and submit the job script:

```
$ qsub rserver.pbs
```

## Connect to RStudio session
1. Check output file (*jobname*.o*JOBNUM*) for details.

Example output file: rserver.o152922
```
1. SSH tunnel from your workstation using the following command:

   ssh -L 8787:node01:9268 tester@loginnode

   and point your web browser to http://localhost:8787.

2. Log in to RStudio Server using the following credentials:
   user: ${USER}
   password: ${RSTUDIO_PASSWORD}
```

2. Open second terminal and run tunneling command from the output file:
```
$ ssh -L 8787:node01:9268 tester@loginnode
```
3. Open a browser and enter the URL from the output file:
```
http://localhost:8787
```
4. Log in with credentials from output file.

You should now be connected to your RStudio session that is running on a cluster compute node. To close the session, select logout or stop session. If you need to reconnect, repeat steps 3 & 4. If you're done with your session, remember to stop the job with qdel.

