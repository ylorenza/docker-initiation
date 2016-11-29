# Prérequis

installer terraform
```shell
brew install terraform
```

# Démarrer l'infrastructure

##Définir les variables d'environnements suivantes

```
export AWS_ACCESS_KEY=change-me
export AWS_SECRET_KEY=change-me
export AWS_REGION=eu-west-1
```
##Modifier le nombre d'instances à démarrer en éditant le fichier `terraform.tfvars`

Il suffit de décommenter des lignes

```
students = [
    "io",
    "europa",
    #"ganymede",
    #"callisto",
    #"amalthea",
```

## Le script suivant lance la création de l'infrastructure sur AWS et éxécute le provisionning avec ansible

```shell
./spawn.sh start
```

# Détruire l'infrastructure

```shell
./spawn.sh stop
```