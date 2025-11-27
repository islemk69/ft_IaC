➜  ft_IaC git:(main) cat README.md 
Phase 1 : Setup et "Hello World"

    Installe Terraform et configure AWS CLI sur ta machine.

    Crée un fichier main.tf.

    Objectif : Déployer une simple instance EC2 via Terraform, s'y connecter en SSH, puis la détruire (terraform destroy).

Phase 2 : Le Réseau (VPC) - Crucial car "Modules externes interdits"

Tu dois construire ton réseau "à la main".

    Crée un VPC.

    Crée des Subnets Publics (pour le Load Balancer) et des Subnets Privés (pour tes serveurs EC2 et ta DB).

    Configure l'Internet Gateway et les Route Tables pour que tes serveurs privés puissent accéder à internet (pour télécharger les paquets/updates) via un NAT Gateway (attention, le NAT Gateway coûte cher, pense à l'éteindre quand tu ne travailles pas !).

Phase 3 : L'Application et l'Image (AMI)

Pour que l'auto-scaling fonctionne, tes serveurs doivent se configurer tout seuls au démarrage.

    Utilise les Launch Templates AWS.

    Utilise le champ user_data (script bash lancé au démarrage de l'EC2) pour :

        Installer Docker & Docker Compose.

        Cloner le repo de l'app ou récupérer l'image Docker.

        Lancer l'app.

    Astuce Cloud-1 : Tu peux réutiliser une partie de ta logique Ansible ici, ou simplement convertir tes tâches Ansible en script Bash pour le user_data.

Phase 4 : Haute Disponibilité (Le cœur du sujet)

    Déploie un Application Load Balancer (ALB) dans les subnets publics.

    Crée un Auto Scaling Group (ASG) qui utilise ton Launch Template.

    Configure l'ASG pour lancer minimum 2 instances dans des subnets privés différents (Zones de disponibilité A et B).

    Attache l'ALB à l'ASG.

    Test : Tue une instance EC2 via la console AWS. L'ASG doit en recréer une nouvelle automatiquement.

Phase 5 : Persistance des Données & Base de Données

    L'app a besoin d'une DB commune pour que les données soient synchronisées.

    Déploie une instance RDS (ex: MySQL ou PostgreSQL selon l'app fournie).

    Injecte l'endpoint (URL) de la RDS dans tes instances EC2 via des variables d'environnement dans le user_data.

    Sécurité : Le Security Group de la RDS ne doit accepter que le trafic venant du Security Group de tes EC2 (pas d'accès public !).

Phase 6 : Abstraction et Variables (Le point "Architecture")

Le sujet demande de simplifier la config .

    Crée un fichier variables.tf.

    Crée une map pour traduire les tailles. Ex: Si l'user met size = "small", Terraform traduit en t2.micro. Si size = "large", traduit en t3.large.

    Fais pareil pour les régions ("Paris" -> "eu-west-3").

Phase 7 : Monitoring et Alerting

    Utilise CloudWatch pour surveiller le CPU de tes instances.

    Configure SNS (Simple Notification Service) pour t'envoyer un email si l'alarme CPU se déclenche ou si une instance échoue au health check.

Phase 8 : Documentation et Coûts

    Génère un schéma de ton infra (tu peux utiliser des outils comme draw.io ou des générateurs automatiques liés à Terraform).

    Vérifie que tu restes dans le "Free Tier" autant que possible. N'oublie pas : "cattle, not pets" shut down your servers when you're not working. Un terraform destroy chaque soir est ton meilleur ami pour le portefeuille.%         # ft_IaC
