# rekrutacja-terraform
Kod infra do zadania rekrutacyjnego.
Resourców jest na tyle mało, że można wszystko zamknąć w jednym pliku
(słaby pomysł jeżeli chodzi o przyszłą rozbudowę)

Logowanie za pamocą service principala

Najpierw wczytajmy zmienne środowiskowe
```
$ source configure-env-variables.sh "<service_principal_secret>"
$ az login --service-principal -u "$ARM_CLIENT_ID" -p "$ARM_CLIENT_SECRET" --tenant "$ARM_TENANT_ID"
```
