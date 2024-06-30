
variable "ssh_authorized_keys" {
  description = "SSH authorized public keys for the instance"
  type        = string
}

variable "availability_domain" {
  description = "The availability domain to host the instance"
  type        = string
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to deploy the instance in"
}

variable "mariadb_user" {
  type        = string
  description = "MariaDB user"
}

variable "mariadb_password" {
  type        = string
  description = "MariaDB password"
}

variable "mariadb_database" {
  type        = string
  description = "MariaDB database"
}

variable "compartment_ocid" {
  type        = string
  description = "The compartment to deploy the instance in"
}

variable "env" {
  description = "The display name prefix of the infrastructure resources"
  type        = string
}

variable "compute_shape" {
  type        = string
  description = "Compute shape to use for the instance"
}

variable "run_koala" {
  type        = bool
  description = "Whether to run the Koala bot"
}

variable "bot_owner" {
  type        = string
  description = "The owner of the bot"
}

variable "discord_token" {
  type        = string
  description = "The bot token"
}

variable "encrypted" {
  type        = bool
  description = "Whether to encrypt the database"
}

variable "gmail_email" {
  type        = string
  description = "The Gmail email"
}

variable "gmail_password" {
  type        = string
  description = "The Gmail password"
}

variable "sqlite_key" {
  type        = string
  description = "The SQLite key"
}

variable "twitch_secret" {
  type        = string
  description = "The Twitch secret"
}

variable "twitch_token" {
  type        = string
  description = "The Twitch token"
}