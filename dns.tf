# --- DNS API → ALB Backend ---
resource "cloudflare_record" "api" {
  zone_id = var.cloudflare_zone_id
  name    = local.api_domain
  content = aws_lb.backend.dns_name
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

# --- DNS Frontend → ALB Frontend ---
resource "cloudflare_record" "frontend" {
  zone_id = var.cloudflare_zone_id
  name    = local.front_domain
  content = aws_lb.frontend.dns_name
  type    = "CNAME"
  proxied = true
  ttl     = 1
}
