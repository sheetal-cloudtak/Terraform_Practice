output "eb" {
	value = aws_elastic_beanstalk_environment.app-prod.cname
}
output "db_endpoint" {
  value = aws_db_instance.mariadb.endpoint
}