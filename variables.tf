variable "private_key" {
  type        = string
  description = "The private key to use for ssh access"
}

variable "compartment_ocid" {
  type        = string
  description = "The compartment to deploy the instance in"
}

variable "env_name" {
  type        = string
  description = "The display name prefix of the infrastructure resources"
}

variable "availability_domain_number" {
  description = "The availability domain to host the instance"
  type        = string
}

variable "compute_shape" {
  type        = string
  description = "Compute shape to use for the instance"
}

variable "mariadb_database" {
  type        = string
  description = "The name of the database"
}

variable "mariadb_user" {
  type        = string
  description = "The name of the database user"
}

variable "mariadb_password" {
  type        = string
  description = "The password of the database user"
}

variable "ssh_authorized_keys" {
  description = "SSH authorized public keys for the instance"
  type        = string
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