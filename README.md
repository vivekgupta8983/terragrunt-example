# Terragrunt Tutorials

## Why we need Terragrunt for Terraform?

1. Terragrunt is a thin wrapper for Terraform to keep your configurations DRY
2. Managing the Infrastructure for multiple environments is complex, even with Terraform workspace and Modules
3. It helps to create Infrastructure for multiple environments from single source, instead of multiple copy of configuration files for each environment
4. We can manage remote state for each environment
5. Terragrunt inherits all the built-in commands of Terraform and some more options as well
6. Terragrunt can pull Terraform configuration code stored in local, remote or any source repository (git)
7. It is a opensource tool, which helps to contribute or make development changes as per client requirement.


## Terraform workspace vs Terragrunt

1. Workspaces are natively built into Terraform, so you don't need to learn/use/maintain/etc an external tool like Terragrunt.
2. Workspaces are natively used by Terraform Cloud (TFC) and Enterprise (TFE). Terragrunt is not natively supported by TFC or TFE       (though there are some workarounds to use them together).
3. Workspaces are natively supported in the Terraform code itself: you can get the name of the workspace using terraform.workspace and have the code behave differently based on that name (e.g., instance_type == terraform.workspace === "dev" ? "t2.micro" : "m4.large").
4. Workspaces allow you to keep one copy of your code, but to have the state of the infrastructure captured in separate state files. This reduces code duplication. With Terragrunt, you do need to create extra files/folders to define each environment, so you do end up with a bit more duplication. Note that this is intentional, as the idea behind Terragrunt is to make those environments visible in your repo (you'll see more about that in the next section), but it does mean having more files/folders to manage.

## Terragrunt workflow

![alt text](docs/img/terragrunt%20workflows.png)

## Terragrunt Core Features

1. we can keep our terrafrom code DRY (Do Not Repeat Your Code).
2. we can keep our Backend Configuration DRY.
3. we can keep our "Terraform CLI" arguments DRY.
4. we can execute Terraform commands on multiple modules at once.
5. we can add hooks(Before hooks, After hooks, and error hooks). hooks are nothing but trigger something before actions.
   1. Before Hooks or After Hooks are a feature of terragrunt that make it possible to define custom actions that will be called either before or after execution of the terraform command.
   
            terraform {
                before_hook "before_hook" {
                    commands     = ["apply", "plan"]
                    execute      = ["echo", "Running Terraform"]
                }
                after_hook "after_hook" {
                    commands     = ["apply", "plan"]
                    execute      = ["echo", "Finished running Terraform"]
                    run_on_error = true
                    }
                }
   2. Error hooks are a special type of after hook that act as exception handlers.

            terraform {
                error_hook "import_resource" {
                    commands  = ["apply"]
                    execute   = ["echo", "Error Hook executed"]
                    on_errors = [
                    ".*",
                    ]
                    }
                }

6. We can work with multiple AWS accounts.
7. Inputs and Locals.
8. Auto-init and Auto-retry.
9. Caching.
10. AWS Auth.
11. Debugging.
12. Lock file Handling.

## Terragrunt Configuration file


1. Terragrunt configuration is defined in a file “terragrunt.hcl”.
2. The data written inside this file “terragrunt.hcl” uses the same HCL syntax as Terraform
3. Terragrunt supports JSON-serialized HCL defined in “terragrunt.hcl.json”
4. Terragrunt identifies “<filename>.hcl” files from the path specified in order:
   1. If CLI option defined, --terragrunt-config
   2. Environment variable, TERRAGRUNT_CONFIG
   3. Current working directory, if terragrunt.hcl file exists
   4. Current working directory, if terraform.hcl.json file exists
   5. Throws error, if not found any one of the above specified approach
5. We can rewrite the hcl configuration files to a canonical format of terragrunt using command
   
        # terragrunt hclfmt
    
    Above command will check for hcl files in recursive order as well.

6. In order to preview the format of the hcl files, instead of overwriting them. Use command
   
        # terragrunt hclfmt –terragrunt-check

7. For more info [Doc](https://terragrunt.gruntwork.io/docs/).

Sample terragrunt configuration file "terragrunt.hcl"

        ## Terrafrom Block

        terraform {
            source = "git::git@github.com:vpc/aws-vpc-network-terraform.git//modules?ref=v1.2.0"
        }

        ## Generate Block

        generate "backend" {
            path      = "s3-backend.tf"
            if_exists = "overwrite_terragrunt"
            contents  = <<EOF
            terraform {
                backend "s3" {
                    bucket  = "terraform-statefiles-aws-vpc"
                    key     = "${path_relative_to_include()}/terraform.tfstate"
                    region  = "us-east-1"
                    encrypt = true
                }
            }
            EOF
        }

        ## Input Block
        inputs = {
            environment       = "Dev"
            Tags = {
                Name = "EC2 Demo"
            }
        }


## Terragrunt Configuration Blocks

1. terraform block
2. remote_state block
3. include block
4. locals block
5. dependency block
6. dependencies block
7. generate block

## Terragrunt Configuration Attributes

1. inputs
2. download_dir
3. prevent_destroy
4. skip
5. iam_role
6. iam_assume_role_duration
7. iam_assume_role_session_name
8. terraform_binary
9. terraform_version_constraint
10. terragrunt_version_constraint
11. retryable_err