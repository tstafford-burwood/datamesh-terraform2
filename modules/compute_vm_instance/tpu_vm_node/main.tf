#--------------------
# COMPUTE TPU VM NODE
#--------------------

resource "google_tpu_node" "tpu_node" {

  // REQUIRED

  name               = var.tpu_node_name
  accelerator_type   = var.tpu_node_accelerator_type
  tensorflow_version = var.tpu_node_tensorflow_version
  project            = var.tpu_node_project_id
  scheduling_config {
    preemptible = var.tpu_node_preemptible
  }

  // OPTIONAL

  description            = var.tpu_node_description
  network                = var.tpu_node_network
  use_service_networking = var.tpu_node_use_service_networking
  labels                 = var.tpu_node_labels
  zone                   = var.tpu_node_zone

}