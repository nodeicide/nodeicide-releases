# [Nodeicide](https://nodeicide.com)
> **Self-Serve Correctness & Isolation Testing for Distributed Systems.**

*"You claim consistency. Prove it."*

## Nodeicide v0.02 -> kubernetes and docker support


Nodeicide is an automated, self-serve correctness testing engine written in Rust. Unlike traditional chaos-engineering tools that only measure liveness, Nodeicide injects active faults (network partitions, process pauses, SIGKILL) while executing concurrent transaction workloads to detect subtle transactional isolation anomalies ($G1c$, $G$-single, $G2$) in real time.

---

##  Key Features

* **Automated Topology Discovery:** Automatically inspects local Docker environments to resolve Postgres primary and replica topologies.
* **Active Fault Injection:** Real-time Kubernetes/Docker container pauses, network partition isolations, and hard process termination during workload execution.
* **Graph-Based Anomaly Detection:** To construct operation dependency graphs ($WW$, $WR$, $RW$) and catch non-serializable transaction cycles.
* **CI/CD Ready Pipeline:** Fast, continuous verification designed to fit directly into automated test suites.

---

## How to install
`$curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nodeicide/nodeicide-releases/main/install.sh | bash`

---

## ⚡ Quickstart

### 1. Prerequisites
* **OS:** Linux (macOS experimental; Windows unsupported).
* **Environment:** Local Docker daemon active.
* **Target:** Postgres primary/replica containers running locally with exposed host ports.

### 2. Run a Correctness Scan

Run Nodeicide against your running container stack by specifying the test duration and concurrent client workload:

```bash
nodeicide --seconds 60 --users 6
```
### What if I have both Docker and Kubernetes active?

if you have both docker and kubernetes instances then you will be given an option between them,
    this option is there regardless if any run postgres, none run postgres or only one
you will be greeted with the following choices in such scenario
```
You have both docker containers and kubernetes pods seperate
you therefore can choose which one we will check for postgres
pick:
 [1] kubernetes
 [2] docker
1 or 2:
```

>[!WARNING]
> NODEICIDE COMES AS IS

