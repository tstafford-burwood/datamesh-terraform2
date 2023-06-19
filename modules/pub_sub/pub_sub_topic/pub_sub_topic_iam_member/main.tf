#--------------------------------
# PUB/SUB TOPIC IAM MEMBER MODULE
#--------------------------------

resource "google_pubsub_topic_iam_member" "member" {

  // REQUIRED

  project = var.project_id
  topic   = var.topic_name
  member  = var.iam_member
  role    = var.role
}