
resource "helm_release" "assignment" {
  name       = "assign-chart"
  chart      = "./app" 
  namespace  = "default"


  values = [
    "${file("./app/values.yaml")}"
  ]


}