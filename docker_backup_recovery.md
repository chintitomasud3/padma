**n8n Backup & Restore Guide (Windows / cmd.exe)**

A clean, step-by-step procedure for backing up and restoring your n8n data volume on Windows using only the Command Prompt (`cmd.exe`).

---

### Prerequisites
- Docker Desktop installed and running
- You are in the folder that contains (or will contain) the backup file
- Open **Command Prompt** (not PowerShell) as Administrator if needed

---

### Step 1: Backup the n8n data volume

```cmd
docker run --rm -v n8n_data:/data -v %cd%:/backup alpine tar czf /backup/n8n_data_backup.tar.gz -C /data .
```

**What this does:**
- Starts a temporary Alpine container
- Mounts your existing `n8n_data` volume to `/data` inside the container
- Mounts the current directory (`%cd%`) to `/backup`
- Creates a compressed archive `n8n_data_backup.tar.gz` of everything inside the volume
- The container is automatically removed after the command finishes (`--rm`)

---

### Step 2: Pull the official n8n image

```cmd
docker pull n8nio/n8n
```

**What this does:**
- Downloads the latest official `n8nio/n8n` image from Docker Hub (or updates it if already present)

---

### Step 3: Create a fresh volume (optional but recommended for clean restore)

```cmd
docker volume create n8n_data
```

**What this does:**
- Creates a new Docker volume named `n8n_data`  
  (Skip this step if the volume already exists and you just want to overwrite its contents)

---

### Step 4: Restore the backup into the volume

```cmd
docker run --rm -v n8n_data:/data -v %cd%:/backup alpine tar xzf /backup/n8n_data_backup.tar.gz -C /data
```

**What this does:**
- Starts another temporary Alpine container
- Mounts the `n8n_data` volume and the current folder
- Extracts the backup archive into the volume
- Container is removed automatically when finished

---

### Step 5: Start the n8n container

```cmd
docker run -d --name n8n -p 5679:5678 -v n8n_data:/home/node/.n8n n8nio/n8n
```

**What this does:**
- Runs n8n in the background (`-d`)
- Names the container `n8n`
- Maps host port **5679** → container port **5678**
- Mounts the restored volume to the correct n8n data directory
- Uses the official `n8nio/n8n` image

---

### Quick Reference – Full Sequence

```cmd
:: 1. Backup
docker run --rm -v n8n_data:/data -v %cd%:/backup alpine tar czf /backup/n8n_data_backup.tar.gz -C /data .

:: 2. Pull image
docker pull n8nio/n8n

:: 3. Create volume (if needed)
docker volume create n8n_data

:: 4. Restore
docker run --rm -v n8n_data:/data -v %cd%:/backup alpine tar xzf /backup/n8n_data_backup.tar.gz -C /data

:: 5. Start n8n
docker run -d --name n8n -p 5679:5678 -v n8n_data:/home/node/.n8n n8nio/n8n
```

---

```
docker run -it --rm --name n8n -p 5679:5678 -e N8N_SECURE_COOKIE=false -e GENERIC_TIMEZONE="Asia/Dhaka" -e TZ="Asia/Dhaka" -v n8n_data:/home/node/.n8n docker.n8n.io/n8nio/n8n
```

### Useful Follow-up Commands

| Action                    | Command                                      |
|---------------------------|----------------------------------------------|
| Check if n8n is running   | `docker ps`                                  |
| View logs                 | `docker logs n8n`                            |
| Stop n8n                  | `docker stop n8n`                            |
| Start existing container  | `docker start n8n`                           |
| Remove container          | `docker rm -f n8n`                           |
| Access n8n                | Open browser → `http://localhost:5679`       |

---

**Notes**
- Always run these commands from the folder that contains (or will contain) `n8n_data_backup.tar.gz`.
- Port `5679` is used on the host so it doesn’t conflict with the default `5678`.
- The backup file is a normal `.tar.gz` – you can copy it to another machine and restore there using the same steps.
