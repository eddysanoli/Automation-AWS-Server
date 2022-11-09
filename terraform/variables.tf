# Note: The values for these variables are found in "terraform.tfvars".

/* ============================================ */
/* USER IPS                                     */
/* ============================================ */

variable "ALMENDRO_IP" {
    type = string
    default = ""
}
variable "RICARDITE_IP" {
    type = string
    default = ""
}

/* ============================================ */
/* EDDYSANOLI.COM SERVER IP                     */
/* ============================================ */

# Eddysanoli.com Server IP Address 
variable "EDDYSANOLI_COM_SERVER_IP" {
    type = string
    default = ""
}

/* ============================================ */
/* NAMECHEAP                                    */
/* ============================================ */

# Namecheap user and API key
# Only available if you have spent more than 50$ or if you have a balance of 50$ or more
variable "NAMECHEAP_USER" {
    type = string
    default = ""
}
variable "NAMECHEAP_API_KEY" {
    type = string
    default = ""
}
