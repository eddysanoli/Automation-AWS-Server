# Note: The values for these variables are found in "terraform.tfvars".

/* ============================================ */
/* MY PERSONAL IP                               */
/* ============================================ */

# My Personal IP Address 
variable "PERSONAL_IP" {
    type = string
    default = ""
}

/* ============================================ */
/* ALMENDRO IP                                  */
/* ============================================ */

# The IP of Almendro 
variable "ALMENDRO_IP" {
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