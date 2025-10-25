variable "instances" {
  description = "List of Ubuntu instances to install K3s on"
  type = list(object({
    name        = string
    ip          = string
    ssh_user    = string
    private_key = string
    role        = optional(string, "master")
  }))
}
