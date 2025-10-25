resource "null_resource" "setup_k3s" {
  for_each = { for inst in var.instances : inst.name => inst }

  # STEP 1: VM’ye bağlan
  connection {
    type        = "ssh"
    host        = each.value.ip
    user        = each.value.ssh_user
    private_key = file("${path.module}/${each.value.private_key}")
  }

  # STEP 2: Dizin oluştur
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/scripts"
    ]
  }

  # STEP 3: Scriptleri kopyala
  provisioner "file" {
    source      = "scripts/"
    destination = "/tmp/scripts"
  }

  # STEP 4: Scriptleri çalıştır
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/scripts/*.sh",
      "sudo /tmp/scripts/prepare_ubuntu.sh",
      "sudo /tmp/scripts/install_k3s.sh ${lookup(each.value, "role", "master")}"
    ]
  }
}
