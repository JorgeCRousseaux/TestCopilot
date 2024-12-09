
1. [Introducción](#introducción)
2. [Instalación y configuración](#instalación-y-configuración)
3. [Nomenclatura](#nomenclatura)
4. [Variables](#variables)
5. [Backend](#backend)
6. [Ficheros](#ficheros)
7. [Seguridad](#seguridad)
8. [Documentación](#documentación)
9. [Tags](#tags)

## Introducción

## Instalación y configuración

Requisitos comunes:

- ***IIMPORTANTE***: Instalar el paquete [`graphviz`](https://graphviz.org/download/).

1. [Guía de configuración de Azure](https://confluence.prosegur.net/pages/viewpage.action?pageId=355144319)
2. [Guía de configuración de AWS](https://confluence.prosegur.net/display/DTIALARMAS/Terraform+para+proyectos+CRA)

## Nomenclatura

La nomenclatura en Terraform se refiere a las convenciones de nombres que se utilizan para organizar y estructurar los recursos, variables, módulos, y otros elementos dentro de la configuración de Terraform. Una nomenclatura clara y consistente es esencial para mantener un código legible, fácil de mantener y escalable, especialmente en proyectos grandes o cuando se trabaja en equipo.

1. Formato:
   - Separadores: Utilizar guión bajo (`_`) para separar las palabras de los nombres de los recursos, variables, módulos o ficheros de terraform (*snake_case*).
   - Identación: Utilizar dos espacios de tabulación en vez de cuatro (tab). Se puede utilizar `terraform fmt` para dar el formato estándar de Terraform (afecta a ficheros *.tf* y *.tfvars*).
   - Comentarios: Recomendable utilizar comentarios en los recursos si se detecta alguna anomalía o algún *edge case*, si es asi, comentarlo en la misma linea (`# COMENTARIO`) del argumento si cabe, si no comentarlo encima del recurso con un comentario multilinea (`/* COMENTARIO */`).

2. Nomenclatura de recursos
   - Los recursos **no** deben tener nombres genéricos tales como *this*, *example* o *main*, salvo que estén dentro de un módulo o en un recurso que se genere con *for_each*.
   - Los recursos que se generan con un *for_each* deben tener nombres pseudo genéricos, ya que el nombre del recuso como tal va a contener el indice de la lista o el nombre del mapa con el que se va a generar.
   - Los recursos deben tener nombres significativos en relación al tipo de recurso que sea, sin tener el nombre, o la abreviación, del recurso. Por ejemplo, en un recurso de tipo **azurerm_network_interface**, un nombre válido seria el nombre de la vm que va a ser conectado (*vm1*), pero no seria válido uno que indique que es una nic (*nic01-vm*). Ya que para hacer referencia a un recurso de terraform es en el siguiente formato **TIPO_DE_RECURSO.NOMBRE_DE_RECURSO.ARGUMENTO**, por tanto va implícito el tipo, no haciendo falta mencionarlo en el nombre.

    ```hcl
    #Ejemplos NO válidos#
    resource "azurerm_network_interface" "this"{
        //configuración
    }

    resource "azurerm_virtual_network" "vnet01"{
        //configuración
    }

    resource "azurerm_subnet" "vm01"{
        for_each = {}//mapa de mapas con la configuración de cada subent
        //configuración
    }

    #Ejemplos válidos#
    resource "azurerm_network_interface" "vm01"{
        //configuración
    }

    resource "azurerm_virtual_network" "spain"{
        //configuración
    }

    resource "azurerm_subnet" "name"{ #Cuando se genere tendrá el siguiente formato: azurerm_subnet.name[INDICE] INDICE es el nombre de cada mapa, que es único e identificativo
        for_each = {}//mapa de mapas con la configuración de cada subent
        //configuración
    }
    ```

3. Nomenclatura de módulos
   - Las invocaciones de módulos **no** deben tener nombres genéricos tales como *this* o *example*.
   - Los módulos que se generan con un *for_each* deben tener nombres pseudo genéricos, ya que el nombre del módulo como tal va a contener el indice de la lista o el nombre del mapa con el que se va a generar.
   - Las invocaciones de módulos deben tener nombres significativos que indiquen en que se van a usar y no lo que van a generar. Por ejemplo, un modulo que genera una virtual network y varias subnets, **no** debería llamarse *vnetsysubnets*, pero si podría llamarse *networking_main*, *madrid*, *brazil_south*.

    ```hcl
    #.modules/networking supongamos que es un modulo que genera una virtual network y varias subnets.

    #Ejemplos NO válidos#
    module "this"{
        source = ".modules/networking"
        //configuración
    }

    module "subnets"{
        for_each = {}//mapa de mapas con la configuración necesaria
        source = ".modules/networking"
        //configuración
    }

    #Ejemplos válidos#
    module "networking"{
        source = ".modules/networking"
        //configuración
    }

    module "region"{//suponiendo que los indices del mapa son las regiones en las que se va a crear la vnet y subnet.
        for_each = {}//mapa de mapas con la configuración necesaria
        source = ".modules/networking"
        //configuración
    }
    ```

4. Nomenclatura de data
   - Los data **no** deben tener nombres genéricos tales como *this*, *example* o *main*.
   - Los data deben tener el nombre del recurso que recupera del cloud, para poder distinguirlo con facilidad.

    ```hcl
    #Ejemplos NO válidos#
    data "azurerm_subnet" "this" {
        //configuración
    }

    #Ejemplos válidos#
    data "azurerm_subnet" "cra1" {
        //configuración
    }
    ```

5. Nomenclatura de locals
   - Los nombres de las variables locales (locals) deben ser significativos.
   - Los nombres de las variables locales (locals) **no** deben ser demasiado cortos o demasiado largos, ni abreviaciones que se puedan confundir.

    ```hcl
    #Ejemplos NO válidos#
    locals {
        a = ["East Asia","Japan East","Korea South"]
        npi = "networkInterfacesID"
        network_interface_application_gateway_backend_address_pool = "SAP-bgwap"
    }

    #Ejemplos válidos#
    locals {
        regions = ["East Asia","Japan East","Korea South"]
        interface_ID = "networkInterfacesID"
        agw_backend = "SAP-bgwap"
    }
    ```

6. Nomenclatura de variables
   - Los nombres de las variables deben ser significativos.
   - Los nombres de las variables **no** deben ser demasiado cortos o demasiado largos, ni abreviaciones que se puedan confundir.

    ```hcl
    #Ejemplos NO válidos#
    variable "a" {} //valor=["East Asia","Japan East","Korea South"]
    variable "npi" {} //valor="networkInterfacesID"
    variable "network_interface_application_gateway_backend_address_pool" {} //valor="SAP-bgwap"

    #Ejemplos válidos#
    variable "regions" {} //valor=["East Asia","Japan East","Korea South"]
    variable "interface_ID" {} //valor="networkInterfacesID"
    variable "agw_backend" {} //valor="SAP-bgwap"
    ```

## Variables

Las variables en Terraform son una parte fundamental de la gestión de la infraestructura como código, ya que permiten parametrizar configuraciones, hacerlas más flexibles y reutilizables, y evitar la repetición de código, y dinamizar las configuraciones, haciendo que el código sea más modular y fácil de adaptar a diferentes entornos o escenarios sin necesidad de modificar el código fuente directamente.
Las variables se definen en bloques variable dentro de un archivo *.tf*. Cada bloque variable incluye un nombre (*obligatorio*) y, opcionalmente, una descripción, un tipo, un valor por defecto, y otras opciones como validación, si es sensible o si puede ser nula.

- Definición mínima de una variable:

  ```hcl
  variable "NOMBRE" {}
  ```

- Definición recomendada de una variable:

  ```hcl
  variable "NOMBRE" {
    description = "Descripción"
  }
  ```

- Definición avanzada de una variable:

  ```hcl
  variable "NOMBRE" {
    description = "Descripción"
    type = TIPO
    default = "Valor por defecto"
    validation {
        condition = "Condición"
        error_message = "Mensaje de error"
    }
    sensitive = "Valor booleano"
    nullable = "Valor booleano"
  }
  ```

El nombre de la variable puede ser cualquier nombre excepto las palabras reservadas:

- `source`
- `version`
- `providers`
- `count`
- `for_each`
- `lifecycle`
- `depends_on`
- `locals`

Argumentos opcionales de las variables:

- `default` - Valor por defecto según tipo de variable.
- `type` - Limitación del tipo de dato que admite la variable.
  - **Básicos**:
    - `string`: Cadenas de caracteres, de define entre comillas dobles `"`: Ejemplo: `"ami-145fs4sa"`.
    - `number`: Valores numéricos. Ejemplo: `6` o `1.457`.
    - `bool`: Valores verdadeos o falses. Ejemplo: `true`.
    - `any`: Cualquier tipo de valor. **NO UTILIZAR**.
  - **Complejos**:
    - `list(<TIPO_BÁSICO>)`: Lista de elementos que se pueden repetir de un mismo tipo. Se define entre corchetes `[]`. Ejemplo: `["ami-145fs4sa","ami-145f567s","ami-145fs4sa"]`.
    - `set(<TIPO_BÁSICO>)`: Lista de elementos únicos de un mismo tipo. Se define entre corchetes `[]`. Ejemplo: `["ami-145fs4sa","ami-145f567s"]`.
    - `tuple([<TIPO_BÁSICO>, ..., <TIPO_BÁSICO>])`:  Lista de elementos de distintos tipos. Se define entre corchetes `[]`. Ejemplo: `["ami-145fs4sa",3, true]`.
      - `map(<TIPO_BÁSICO>)`: Colección de elementos de un mismo tipo, en formato `clave = valor`. Se define entre llaves `{}`. Ejemplo: `{ "nombre" = "Pepito", "apellido" = "Grillo"}`
    - `object(<KEY>=<TIPO_BÁSICO>, ..., <KEY>=<TIPO_BÁSICO>,)`: Colección de elementos de distintos tipos, en formato `clave = valor`. Se define entre llaves `{}`. Ejemplo: `{ "nombre" = "Pepito", "apellido" = "Grillo", "edad" = 26, "casado" = true, "hijos" = ["Ana", "Juan"]}`
- `description` - Descripción significativa del uso y tipo de la variable.
- `validation` - Bloque de validación de la variable. Se puede utilizar en conjunto con `type`.
  - `condition`: Función o funciones para la validación.
  - `error_message`: Mensaje de error si la comprobación de la función o funciones devuelve un valor falso. Debe ser un mensaje claro y explícito.
- `sensitive` - Limita la aparición por consola de valores sensibles tanto en el plan como en el apply. Valor booleano.
- `nullable` - Controla si la variable puede o no ser nula (`null`). Utilizada principalmente en módulos. Si se permite y tiene un valor por defecto, utilizará dicho valor, si no tendrá el valor `null`. Valor booleano.

## Backend

El backend en Terraform se refiere a la configuración que determina cómo y dónde se almacena el estado de la infraestructura gestionada. El estado de Terraform es un archivo que contiene información sobre los recursos que Terraform ha creado o gestionado, y es crucial para la operación de Terraform, ya que permite a Terraform conocer el estado actual de la infraestructura para planificar y aplicar cambios de manera correcta.

Propósitos del estado:

- **Mapeo de recursos**: Ayuda a Terraform a identificar los recursos en la infraestructura.
- **Detección de cambios**: Permite a Terraform detectar diferencias entre la configuración deseada y el estado actual.
- **Sincronización de cambios**: Facilita la aplicación de cambios de manera precisa, minimizando la creación de recursos duplicados o la eliminación de recursos que deberían permanecer.

Por defecto, Terraform almacena el estado localmente en un archivo llamado `terraform.tfstate` en el mismo directorio donde se ejecuta Terraform. Sin embargo, para equipos que colaboran o para entornos más avanzados, es recomendable utilizar un backend remoto.
Tipos de backend más comunes:

- **Local**: Almacena el estado en el sistema de archivos local.
- **Remoto**: Almacena el estado en un servicio remoto, como un bucket de S3, Google Cloud Storage, Azure Blob Storage, etc.

Ventajas de usar un backend remoto:

- **Colaboración**: Permite que múltiples usuarios trabajen en la misma infraestructura compartiendo el estado.
- **Seguridad**: Los backends remotos pueden ofrecer mayor seguridad y control de acceso.
- **Respaldo y recuperación**: Facilita la copia de seguridad y la recuperación en caso de fallos.

## Ficheros

En un proyecto de Terraform, es fundamental organizar y estructurar los archivos de configuración para facilitar la gestión y el mantenimiento de la infraestructura. A continuación, se explica la función de los archivos base típicos que se utilizan en un repositorio de Terraform:

1. **providers.tf**
   - En este archivo se definen los providers que Terraform utilizará para interactuar con los diferentes servicios de la nube o de otras plataformas.

    ```hcl
    provider "aws" {
      region = "us-west-2"
    }

    provider "azurerm" {
      features {}
    }
    ```

2. **data.tf**
   - En este archivo se definen los data sources (datos que se recuperan de recursos existentes).

   ```hcl
    data "aws_ami" "example" {
        most_recent = true
        owners      = ["self"]
    }

    data "azurerm_network_interface" "example" {
        name                = "acctest-nic"
        resource_group_name = "networking"
    }
    ```

3. **variables.tf**
    - En este archivo se definen las variables ques se van a utilizar para crear los recursos.

    ```hcl
    variable "instance_type" {
        description = "Type of EC2 instance"
        type        = string
        default     = "t2.micro"
    }

    variable "location" {
        description = "Zona donde se va a desplegar el recurso"
        type = string
    }
    ```

4. **variables/env.tfvars**
    - En este archivo se definen los valores de las variables ques se van a utilizar para crear los recursos, en una misma carpeta (variables) y un archivo distinto por entorno. Ejemplo: **prod.tfvars** o **pre.tfvars**

    ```hcl
    instance_type = "t3.micro"
    location = "europe-west"
    ```

5. **backend.tf**
   - En este archivo se definen la configuración del backend, donde  se va a guardar el estado de Terraform.
   - Se definen sin ningún argumento. Los valores se pasan en el fichero de **backend/env.tfvars**. No hay que definir las variables que usa.

    ```hcl
    terraform{
        backend "s3" {}
    }

    terraform{
        backend "azurerm" {}
    }
    ```

6. **backend/env.tfvars**
   - En este archivo se definen los valores del backend, en una misma carpeta (backend) y un archivo distinto por entorno. Ejemplo: **prod.tfvars** o **pre.tfvars**

    ```hcl
    # Backend S3
    bucket = "my-tf-state-bucket"
    key    = "path/to/my/key"
    region = "us-west-2"

    # Backend azurerm
    resource_group_name  = "la-brs-prod-rg-terraform"
    storage_account_name = "stmpaterraform"
    container_name       = "tfstate"
    key                  = "terraform-cra-chile-brs-prod.tfstate"
    ```

7. **locals.tf**
   - En este archivo se definen variables locales, valores que se pueden definir a partir de variables o recursos o valores definidos arbitrariamente y que se van a usar en la configuración de los recursos.

    ```hcl
    locals {
        instance_count = var.environment == "production" ? 5 : 1
        prefix = "az-tf"
    }
    ```

8. **Otros**
   - En estos archivos se definen recursos e invocaciones de módulos. Es recomendable nombrar estos archivos de manera descriptiva, ya sea por el conjunto de recursos que crea son relacionados entre si o los recursos que crea son para un mismo fin. Ejemplos:
     - **network.tf**: Grupo de recursos que generan la parte de networking, como por ejemplo una vnet, subnets, tabla de rutas...
     - **vm.tf**: Grupo de recursos que genera una maquina virtual y todo lo que necesita, por ejemplo un data disk, nic, nsg...

## Modulos

Un módulo en Terraform es un conjunto de recursos agrupados que se gestionan como una unidad. Los módulos permiten encapsular y reutilizar configuraciones de infraestructura, simplificando la implementación y reduciendo la repetición de código. Un módulo puede ser tan simple como un solo recurso o tan complejo como una arquitectura completa que incluye múltiples recursos.

Ventajas de los módulos:

- **Reutilización**: Los módulos permiten definir una vez una configuración y reutilizarla en múltiples proyectos o entornos.
- **Organización**: Facilitan la organización del código en unidades lógicas, haciendo más sencillo el mantenimiento y la comprensión del mismo.
- **Abstracción**: Permiten abstraer la complejidad de los detalles de implementación, exponiendo solo las interfaces necesarias (variables y outputs).
Estructura básica de un módulo:

Un módulo generalmente contiene los siguientes archivos:

- ***main.tf***: Define los recursos principales que el módulo gestiona.
- ***variables.tf***: Define las variables que el módulo acepta para personalizar su comportamiento.
- ***outputs.tf***: Define los valores de salida que el módulo expone después de ser aplicado.

Se han creado varios módulos para el uso y reutilización. Se guardan en [Github](https://github.com/prosegur?q=alarms-cloudops-terraform-module&type=all&language=&sort=). Todos los repositorios de módulos tienen el siguiente formato: `alarms-cloudops-terraform-module-CLOUD-NOMBRE`.

- `CLOUD`: Indica si es un módulo para Azure o AWS. Valores admitidos `azure` o `aws`.
- `NOMBRE`: Un nombre descriptivo que indica el recurso o grupo de recursos que crea.

Si se detecta un patron a la hora de crear recursos, y se prevé que se puede reutilizar en futuros despliegue, es recomendable crear un módulo para ello y subirlo al Github para que todos podamos hacer uso del mismo. Al subirlo, respetar el formato del nombre, indicado más arriba.

## Snippets

Los snippets en Terraform son fragmentos de código reutilizables que se pueden utilizar para agilizar la escritura de configuraciones de infraestructura.

Ventajas de Usar Snippets:

- **Ahorro de Tiempo**: Al usar snippets, los desarrolladores pueden insertar rápidamente estructuras de código comunes sin necesidad de escribirlas desde cero cada vez.
- **Consistencia**: Los snippets ayudan a mantener la consistencia en la forma en que se escriben y estructuran las configuraciones de Terraform dentro de un equipo.
- **Reducción de Errores**: Al utilizar fragmentos de código predefinidos, se minimiza el riesgo de errores tipográficos o de sintaxis.
- **Facilidad de Uso**: Los snippets son fáciles de utilizar, especialmente en editores de código que soportan su autocompletado, lo que simplifica la experiencia del desarrollador.

Visual Studio Code soporta la inserción de snippets. Para utilizarlos, se suelen seguir los siguientes pasos:

1. **Activar Snippets**:
   - Ejecutar `ctrl + shift + p` y buscar `Snippets: Configure snippets`.
    ![alt text](vscode_snippets1.png)
   - Elegir opción de `New Global Snippets file`.
    ![alt text](vscode_snippets2.png)
   - Nombre del archivo `terraform`.
    ![alt text](vscode_snippets3.png)

2. **Definir Snippets Personalizados**:
   - Clonar repositorio de [snippets](https://github.com/prosegur/alarms-cloudops-terraform-snippets)
   - ejecutar el script para sincronizar los cambios del repo con los del Visual Studio Code (o copiarlo a mano o editar el fichero y pegar el contenido).
      - Windows:

        ```cmd
        git pull
        copy /y terraform.code-snippets  %APPDATA%\Code\User\snippets\terraform.code-snippets
        ```

      - Linux:

        ```sh
        git pull
        cp -u terraform.code-snippets  /mnt/c/Users/$(cmd.exe /c "echo %APPDATA%" | tr -d '\r' | awk -F\\ '{print $3}')/AppData/Roaming/Code/User/snippets/terraform.code-snippets
        ```

3. **Utilizar los sinippets**.
   - Ejecutar `ctrl + shift + p` y buscar `Snippets: Insertar Snippet`.
    ![alt text](vscode_snippets4.png)
   - Tambien se puede utilizar directamente en los ficheros de terraform pulsando `ctrl + espacio`
         ![alt text](vscode_snippets6.png)
   - Filtrar y seleccionar el snippet que se quiera usar. Al insertarse se va a resaltar los campos a rellenar. Ir completando cada campo y tabulando para ir al siguiente.
   ![alt text](vscode_snippets5.png)

## CI/CD

https://www.runatlantis.io/docs/repo-level-atlantis-yaml.html

Atlantis es una herramienta de código abierto que facilita la gestión colaborativa de Terraform mediante la automatización de los flujos de trabajo dentro de GitHub. Atlantis permite a los equipos ejecutar comandos de Terraform en respuesta a los eventos de GitHub, como pull requests, sin necesidad de acceso directo al entorno donde se ejecutan estos comandos, mejorando la seguridad y la colaboración.

- Automatización en Pull Requests: Atlantis se integra con GitHub y se activa cuando se abre, actualiza o comenta en un pull request. Esta integración permite que los comandos de Terraform, como plan, apply, y destroy, se ejecuten directamente desde la interfaz de la plataforma sin que los usuarios tengan que acceder manualmente a la infraestructura.

- Flujo de Trabajo Típico con Atlantis:
  - Se crea un pull request que contiene cambios en los archivos de Terraform.
  - Atlantis detecta este evento y ejecuta automáticamente terraform plan, generando un plan de ejecución.
  - El plan se presenta como un comentario en el pull request, permitiendo que otros miembros del equipo lo revisen.
  - Una vez aprobado, un miembro del equipo puede comentar atlantis apply para que Atlantis aplique los cambios descritos en el plan.
  - Atlantis ejecuta terraform apply y, si es exitoso, comenta en el pull request con los resultados de la ejecución.
- Configuración de Atlantis: Atlantis se despliega como un servicio que escucha los webhooks de la plataforma de control de versiones. Se configura mediante un archivo YAML (atlantis.yaml), donde se pueden definir los proyectos, los directorios donde se encuentran los archivos de Terraform, y las reglas que determinan cuándo y cómo ejecutar los comandos de Terraform.

Se ha configurado un workflow similar al siguiente para el analisis:

```yaml
version: 3
automerge: true
autodiscover:
  mode: auto
parallel_plan: true
parallel_apply: true
abort_on_execution_order_fail: true
projects:
- name: Prod
  branch: /master/
  dir: .
  workspace: default
  terraform_version: latest
  delete_source_branch_on_merge: true
  repo_locks:
    mode: on_plan
  autoplan:
    when_modified: ["*.tf", "../modules/**/*.tf", ".terraform.lock.hcl"]
    enabled: true
  plan_requirements: [mergeable, approved, undiverged]
  apply_requirements: [mergeable, approved, undiverged]
  import_requirements: [mergeable, approved, undiverged]
  silence_pr_comments: ["apply"]
  execution_order_group: 1
  workflow: myworkflow1

- name: NonProd
  branch: /develop/
  dir: .
  workspace: default
  terraform_version: latest
  delete_source_branch_on_merge: true
  repo_locks:
    mode: on_plan
  autoplan:
    when_modified: ["*.tf", "../modules/**/*.tf", ".terraform.lock.hcl"]
    enabled: true
  plan_requirements: [mergeable, approved, undiverged]
  apply_requirements: [mergeable, approved, undiverged]
  import_requirements: [mergeable, approved, undiverged]
  silence_pr_comments: ["apply"]
  execution_order_group: 2
  workflow: myworkflow2

workflows:
  myworkflow:
    plan:
      steps:
      - run: my-custom-command arg1 arg2
      - run:
          command: my-custom-command arg1 arg2
          output: hide
      - init
      - plan:
          extra_args: ["-lock", "false"]
      - run: my-custom-command arg1 arg2
    apply:
      steps:
      - run: echo hi
      - apply
  myworkflow2:
    plan:
      steps:
      - run: my-custom-command arg1 arg2
      - run:
          command: my-custom-command arg1 arg2
          output: hide
      - init
      - plan:
          extra_args: ["-lock", "false"]
      - run: my-custom-command arg1 arg2
    apply:
      steps:
      - run: echo hi
      - apply
```

## Seguridad

[Checkov](https://github.com/bridgecrewio/checkov-action) es una herramienta de código abierto que se utiliza para analizar y asegurar la infraestructura como código (IaC). Su objetivo principal es identificar configuraciones incorrectas, vulnerabilidades y problemas de cumplimiento en los archivos que definen la infraestructura, como los escritos en Terraform, CloudFormation, Kubernetes, Dockerfiles, entre otros.

Principales Características de Checkov:

- Escaneo de IaC: Checkov escanea archivos de infraestructura como código para encontrar configuraciones que no cumplan con las mejores prácticas de seguridad. Esto incluye configuraciones de red, permisos de acceso, y encriptación de datos, entre otros.
- Soporte para Múltiples Formatos: Checkov soporta varios lenguajes y formatos de IaC, incluidos Terraform, CloudFormation, Kubernetes, Helm, Dockerfiles, ARM, Bicep, y más.
- Políticas de Seguridad: La herramienta viene con más de 1000 políticas de seguridad predefinidas que cubren diversas plataformas en la nube, como AWS, Azure y Google Cloud. Estas políticas ayudan a garantizar que la infraestructura cumpla con los estándares de seguridad y cumplimiento.
- Integración con CI/CD: Checkov se integra fácilmente en pipelines de CI/CD, lo que permite escanear automáticamente los cambios en la infraestructura como código cada vez que se realiza un commit o se ejecuta una build. Esto ayuda a identificar problemas de seguridad en etapas tempranas del desarrollo.
- Resultados Personalizables: Los resultados del escaneo pueden ser exportados en varios formatos, como JSON, JUnit XML, SARIF, entre otros, lo que facilita su integración con otras herramientas de análisis y reporte.
- Detección de Secretos y Vulnerabilidades: Además de configuraciones incorrectas, Checkov también es capaz de detectar secretos mal gestionados y vulnerabilidades en las imágenes de contenedores.

Se ha configurado un workflow similar al siguiente para el análisis:

```yaml
on: [push]
jobs:
  checkov-job:
    runs-on: ubuntu-latest
    name: checkov-action
    steps:
      - name: Checkout repo 
        uses: actions/checkout@master

      - name: Run Checkov action
        id: checkov
        uses: bridgecrewio/checkov-action@master
        with:
          directory: .
          skip_check: TBD # optional: skip a specific check_id. can be comma separated list
          quiet: true # optional: display only failed checks
          soft_fail: false # optional: do not return an error code if there are failed checks
          framework: terraform # optional: run only on a specific infrastructure {cloudformation,terraform,kubernetes,all}
          output_format: sarif # optional: the output format, one of: cli, json, junitxml, github_failed_only, or sarif. Default: sarif
          output_file_path: reports/results.sarif # folder and name of results file
          output_bc_ids: true # optional: output Bridgecrew platform IDs instead of checkov IDs
          var_file: TBD # optional: variable files to load in addition to the default files. Currently only supported for source Terraform and Helm chart scans.
          log_level: DEBUG # optional: set log level. Default WARNING
          config_file: path/this_file
```

Se ejecuta al subir los cambios a Github y analiza el código en busca de vulnerabilidades de seguridad, fallando el despliegue si se encuentran vulnerabilidades.

## Documentación

Al crear un código de Terraform, se debe generar una pequeña documentación con lo desplegado que debe ir en el repositorio donde se guarda el código. Para ello hay que generar los siguientes documentos:

- **README.md**: Documento general con los recursos desplegados, las variables que emplea, outputs... y demás información relativa al código de Terraform. Esto se genera y actualiza automáticamente a subir el código al repositorio mediante un [Github Action](https://github.com/prosegur/alarms-cloudops-actions-repository) de [terraform-docs](https://terraform-docs.io/)
  - ***IMPORTANTE***: borrar los README que se crean al generar el repositorio para el código del proyecto, para que no haya conflicto ni ensucien el repositorio (ya que no tienen nada que ver con el uso del mismo).
  - Si se quiere añadir más información al **README.md**, se puede añadir modificando el fichero, pero dejando intacto todo lo que hay entre los comentarios `<!-- BEGIN_TF_DOCS -->` y `<!-- END_TF_DOCS -->`. Se puede editar tanto antes como después, aunque es recomendable hacerlo antes.
- **Gráfico de la infraestructura**: Gráfico a partir del código de Terraform, de los recursos que se han desplegado. Puede ser con una o ambas de las siguientes opciones:
  - Esto se genera con [***terraform graph***](https://developer.hashicorp.com/terraform/cli/commands/graph). `terraform graph | dot -Tpng > graph.png` para generar la imagen. Una vez generada la imagen con el grafo, añadirla al **README.md**, al principio de todo. Con el siguiente formato : `![Gráfico de infraestructura de Terraform](<graph.png>)`.
  - Drawio. Diseño de arquitectura a alto nivel de los recursos desplegados con terraform.

## Tags

Azure: Obligatorio al menos el tag de AC. Solo seria necesario ponerlos a nivel de Resource Group, ya que se heredan en los recursos que pertenecen a ese RG. Si un recurso en particular se necesita algun tag adicional, se puede poner a dicho recurso.

AWS: Poner los tags comunes a los recursos a nivel de provider, ya que con eso se añadiran a los recursos desplegados. Si un recurso en particular se necesita algún tag adicional, se puede poner a dicho recurso.


