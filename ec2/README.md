# EC2 instance

Configuration in this directory creates EC2 instance. The file `vpc.tf` creates the network resources needed to spin up a new instance like: `vpc`, `subnet`, `security group`, etc.
It also install `docker` and `java` on the instance startup using `UserData` resource.

## Usage

First, you need to override some variables to point to your AWS resources. You can do it changing the `default` value inside the `variables.tf` file or passing `-var` to the apply command. The variables you must change are:
* aws_access_key
* aws_secret_key
* aws_key_pair_name

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```
or

```bash
$ terraform apply -var aws_key_pair_name=... -var xxx=...
```


Run `terraform destroy` when you don't need these resources anymore.