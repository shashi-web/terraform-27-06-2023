# **Terraform Infrastructure Deployment**

This repository contains the Terraform configuration files to deploy the infrastructure for an Nginx server on a cloud provider. The infrastructure setup includes the creation of a Virtual Private Cloud (VPC), subnets, route tables, security groups, an Nginx server instance, and CloudWatch resources for monitoring.

## **Prerequisites**

- Terraform: Make sure you have Terraform installed on your local machine.

## **Usage**

Follow the steps below to deploy the infrastructure using Terraform:

1. Clone this repository:
    
    ```
    git clone https://github.com/shashi-web/terraform-27-06-2023.git
    
    ```
    
2. Initialize Terraform:
    
    ```
    
    terraform init
    
    ```
    
3. Modify the variables:
    - Open the **`variables.tf`** file and update the values according to your requirements. Specifically, set the values for **`cidr_block`**, **`subnet_cidr_block`**, **`image_name`**, **`public_key`**, **`script_file`**, **`server_name`**, and **`keyname`**.
4. Deploy the infrastructure:
    
    ```
    terraform apply
    
    ```
    
5. Review the planned changes and confirm the deployment by typing **`yes`**.
6. Wait for Terraform to provision the infrastructure. Once the deployment is complete, you will see the output with relevant information, including the Nginx server's public IP address.
7. Access the Nginx server:
    - Open a web browser and enter the Nginx server's public IP address. You should see the default Nginx landing page if everything was set up correctly.

## **CloudWatch Monitoring**

This infrastructure deployment includes CloudWatch resources for monitoring the Nginx server instance. The following resources have been created:

### **Instance Status Alarm**

- Name: **`instance-status-alarm`**
- Description: Alarm for instance status check failure
- Metric: **`StatusCheckFailed`** in the **`AWS/EC2`** namespace
- Comparison Operator: **`GreaterThanOrEqualToThreshold`**
- Threshold: **`1`**
- Evaluation Periods: **`1`**
- Actions: An SNS topic **`arn:aws:sns:us-east-1:419716525079:demo:fde4395f-33cf-4d78-a4dc-4e683e36af8f`** will be triggered when the alarm state is reached.
- Dimensions: The alarm is associated with the instance ID of the Nginx server.

### **CloudWatch Dashboard - Nginx2 Dashboard**

- Name: **`nginx2-dashboard`**
- Widgets: The dashboard includes the following widgets:
    - A text widget displaying the heading "# Instance Status".
    - An alarm widget displaying the **`Instance Status Alarm`** created above, with a period of **`300`** seconds, using the **`SampleCount`** statistic, and set in the **`us-east-1`** region.
    - A metric widget displaying the **`CPU Utilization`** metric from the **`AWS/EC2`** namespace, with an average statistic, a period of **`300`** seconds, and set in the **`us-east-1`** region. The widget's Y-axis is configured to display values from 0 to 100 without units.

## **Project Structure**

The project structure is organized as follows:

```
.
├── main.tf
├── variables.tf
├── modules
│   ├── vpc
│   ├── subnets
│   ├── route_table
│   ├── security_groups
│   └── instance
├── nginx-entry-script.sh
└── aws_cloudwatch.tf

```

- **`main.tf`**: This file is the main Terraform configuration file that orchestrates the deployment of various modules.
- **`variables.tf`**: This file contains the input variables used throughout the configuration. Modify these variables to customize the deployment.
- **`modules`**: This directory contains subdirectories representing different modules used in the infrastructure deployment. Each module encapsulates a specific component's configuration.
- **`nginx-entry-script.sh`**: This is the script file used for configuring the Nginx server.
- **`aws_cloudwatch.tf`**: This file contains the configuration for the CloudWatch resources, including the instance status alarm and the CloudWatch dashboard.