# Phase 0: Use the Repository as a Template

Use the repository as a template by clicking the "Use this template" button. This option allows you to create a new repository with the same directory structure and files as the original, but without copying the commit history.

Keep It Private: Ensure you select the "Private" option when creating your repository to keep your work and sensitive information secure.

# Phase 1: Infrastructure

## Setting Up Your Environment with OVH API Keys

### Overview

This guide will walk you through setting up OVH API keys and configuring your GitHub repository secrets and variables for the community-node-ovh project.

## Step 1: Create OVH API Keys

1. Generate API Keys: Visit the OVH API token creation page for your region:

- For OVH US: [Create OVH US API Tokens](https://us.ovhcloud.com/auth/api/createToken?GET=/*&POST=/*&PUT=/*)
- For OVH EU: [Create OVH EU API Tokens](https://www.ovh.com/auth/api/createToken?GET=/*&POST=/*&PUT=/*)

### Security Note

**Important**: Never save these keys locally or share them with anyone. Always handle your API keys securely.

## Step 2: Add API Keys to GitHub Secrets

Navigate to GitHub Secrets: Go to your GitHub repository's settings page at Settings > Secrets and variables > Actions > Secrets > Repository secrets

Enter API Keys: Add each of the following as new secrets:

- `OVH_APPLICATION_KEY`
- `OVH_APPLICATION_SECRET`
- `OVH_CONSUMER_KEY`

## Step 3: Set Up GitHub Environment Variables

Navigate to GitHub Variables: Go to your GitHub repository's settings page at Settings > Secrets and variables > Actions > Variables > Repository variables

Configure Variables: Add and configure the following environment variables:

- `TF_VAR_ovh_endpoint`: Choose between "ovh-us" for OVH US or "ovh-eu" for OVH EU.
- `TF_VAR_ovh_project_name`: Enter your project (node) name, using lower case letters and underscores.
- `TF_VAR_ovh_project_id`: Find your project ID in the OVH Public Cloud, under your [Project Details](https://www.ovh.com/manager/#/public-cloud/?onboarding). It is located in the left corner of the project page.
- `INSTANCE_TYPE`: Specify your instance type. Options include "eu_small", "eu_medium", "eu_large", "us_small", "us_medium", and "us_large".

## Step 4: Trigger the "Infrastructure Up" Action

- **Navigate to GitHub Actions**: Go to your GitHub repository's main page and click on the "Actions" tab. This will show you a list of available workflows.

- **Trigger the Workflow** Click on the workflow to open its details. You will see a button labeled "Run workflow" or similar. Click this button.

- **Monitor the Workflow**: Once triggered, you can watch the progress of your workflow in real-time. GitHub Actions provides a detailed log of each step being executed, so you can see exactly what's happening. If there are any issues, the logs can help you identify and troubleshoot them.

**Caution**: Managing Kubernetes Instances
After finishing a work session with GitHub Actions, always check your OVH Cloud panel to confirm there's only one Kubernetes instance running. If you find multiple instances:

- **Start Over**: Remove the ./infra/terraform.tfstate file from your repository to reset your setup. This file, which tracks state changes in your infrastructure, is automatically generated when you modify your cluster. Removing it will allow you to start fresh.

**Remember, this caution helps prevent unintended costs and resource conflicts within your OVH Cloud account. Always keeping your cloud resources in check is crucial for maintaining a clean and cost-effective infrastructure setup.**

### Conclusion

You have now successfully configured OVH API keys and set up the necessary GitHub secrets and environment variables for your project. This setup is crucial for managing your project's infrastructure securely and efficiently.

# Phase 2: Witnesses

## Step 1: Setup Kubernetes Config

- Access OVH Public Cloud: Log in to your OVH account and navigate to the Public Cloud section. Open your project details.

- Navigate to Kubernetes Cluster: In the left sidebar menu, select "Managed Kubernetes Service". Wait until your Kubernetes instance is ready. You should see a cluster with the name you selected during the initial setup.

- Download kubeconfig: In the cluster details page, find the "Access and Security" section. Click on "kubeconfig" to download the configuration file.

## Step 2: Configure GitHub Secret:

- Open the kubeconfig file with a text editor.
- Go to your repository settings on GitHub, then navigate to Secrets and Variables > Actions > Secrets.
- Create a new repository secret named KUBE_CONFIG and paste the content of your kubeconfig file.

## Step 3: Create Your Witness Signing Key

- **Open CLI Wallet**: Access your command-line interface wallet.

- **Generate Key Pairs**: Use the suggest_brain_key method to generate a new pair of public/private keys. This key pair will be used by your node.

- **Example Command and Output:**

`suggest_brain_key`

This will generate output similar to:

```json
{
  "brain_priv_key": "EXAMPLE PRIVATE KEY",
  "wif_priv_key": "5J...",
  "pub_key": "RQR..."
}
```

## Step 4: Become a Witness

- **Upgrade Account**: Create or use an existing account through the portal. Upgrade it to a lifetime member.

- **Join Witnesses**: In the portal, navigate to the voting section and select "Join witnesses". Use the public key generated in the previous step as your signing key.

## Step 5: Get Yout Witness ID

- List Witnesses: Use the CLI wallet to execute the list_witnesses method to find your witness ID.

`list_witnesses "revolution-whales" 1`

```json
[["revolution-whales", "1.6.111"]]
```

### Step 6: Encode Your Signing Private Keys to Base64

Kubernetes requires secrets to be stored in Base64 format. We'll encode your keys using a script provided in the repository.

#### Encoding the Private Key

1. **Open Your Terminal**: Navigate to the directory where your repository is cloned.

2. **Run the Encoding Script**: Execute the following command, replacing `<pub_key>` and `<wif_key>` with your actual public and WIF (Wallet Import Format) keys:

```bash
./bin/private_key_b64.sh <pub_key> <wif_key>
```

Example Command:

```bash
./bin/private_key_b64.sh RQRX7CrBrSSkYdW4BuqUGFZcTeZjq2LXGk9KvwxUJVKYi9qe6ZD7XM 5J6aHspD8tnWAQ6QAyhRbuch9uy8sEVjP6eF1QP4PBfrexVrMtF
```

Saving the Output as a GitHub Secret:

- **Access GitHub Secrets**: Go to your repository on GitHub, navigate to Settings > Secrets and Variables > Actions.
- **Create New Secret**: Click on New repository secret. Use the naming convention {WITNESS_NAME}\_WITNESS_PRIVATE_KEY for the "Name" field, replacing {WITNESS_NAME} with your chosen witness name (e.g., REVOLUTION_WHALES_WITNESS_PRIVATE_KEY).
- **Paste the Output**: Enter the Base64-encoded private key (the output from the script) into the "Value" field.

### Step 7: Encode Your Witness ID to Base64

Next, we'll encode your witness ID in a similar fashion.

- **Run the Encoding Script for Witness ID**: With your terminal still open, execute the command below, replacing 1.6.111 with your actual witness ID:

```bash
./bin/witness_id_b64.sh 1.6.111
```

Saving the Output as a GitHub Secret:

- **Repeat the Process for Saving a Secret**: Go back to Settings > Secrets and Variables > Actions in your GitHub repository.
- **Create New Secret for Witness ID**: This time, name the secret {WITNESS_NAME}\_WITNESS_ID, following the same replacement rule for {WITNESS_NAME}.
- **Paste the Output**: Enter the Base64-encoded witness ID into the "Value" field.

### Step 8: Final Action: Trigger the "Nodes Up" GitHub Action
- **Navigate to GitHub Actions:** In your GitHub repository, click on the "Actions" tab to view available workflows.
- **Locate the "Nodes Up" Workflow:** Find the workflow named "Nodes Up" or a similar title that indicates it's responsible for bringing your nodes online.
- **Initiate the Workflow:** Click on "Nodes Up" to open its details, then look for a button labeled "Run workflow" or something similar. Click this button to start the process.
