# Tagging

La asignación de etiquetas o "tags" es una práctica fundamental para la organización, gestión y control de los recursos en la nube. Las etiquetas permiten a las organizaciones tener una visibilidad clara sobre sus entornos, permitiendo un control eficiente sobre costos, auditorías, y cumplimiento de normativas. Este documento establece las pautas mínimas para el etiquetado de recursos en AWS y Azure usando Terraform.

## Tags

A continuación, se definen los tags mínimos que deben aplicarse a todos los recursos. Estos tags aseguran consistencia, trazabilidad y alineación con las prácticas de gestión de recursos en la nube.

AC: Indica el área de Analítica Contable, utilizado para controlar los recursos destinados a esta función. Los valores de cada país:

- España - ES0063/ES990013/A200/C300
- Argentina - AR0052/AR999999/A211/C300
- Portugal - PT0063/PT999999/A211/C300
- Perú - PE0063/D01A0/A211/CA300
- Colombia - CO0078/C99A2/A211/CA300
- Chile - CL0053/L13A0/A211/CA300
- Paraguay - PY0036/Y01AS/A211/CA300
- Uruguay - UY0028/U09A1/A211/CA300
- Gastos comunes - ES0015/ES990013/A200/U187

Producto: Especifica el nombre de la vertical de producto al que el recurso está asociado. Esto ayuda a distinguir y gestionar los recursos por producto. Deben ir en mayúsculas. Ejemplo de producto:

- CRA
- SMART
- SMARTIS
- VIDEO

Entorno: Indica el entorno en el que se ha desplegado el recurso. Deben ir en mayúsculas. Los posibles valores son:

- PROD: Producción
- DEV: Desarrollo
- PRE: Pre-producción

Pais: Se refiere al país donde está desplegado el recurso. Deben ir en mayúsculas. El valor es la abreviación del país de acuerdo con los siguientes códigos:

- Alemania: DE
- Argentina: AR
- Australia: AU
- Brasil: BR
- Chile: CL
- China: CH
- Colombia: CO
- Costa Rica: CR
- El Salvador: SV
- España: ES
- Francia: FR
- Guatemala: GT
- Honduras: HN
- India: IN
- México: MX
- Nicaragua: NI
- Paraguay: PY
- Perú: PE
- Portugal: PT
- Singapur: SG
- Sudáfrica: SD
- Uruguay: UY

PBI: Etiqueta específica de PowerBI que se utiliza para identificar y distinguir los costes asociados a las aplicaciones o herramientas contratadas. Deben ir en mayúsculas.
Creado: Fecha de creación del recurso, en formato DD/MM/YY.
Modificado: Fecha de modificación del recurso, en formato DD/MM/YY. Debe ser la misma que la fecha de creación hasta que se modifique el recurso.

## AWS

AWS permite el uso de etiquetas tanto a nivel de recursos individuales como a nivel de la cuenta, lo cual permite establecer reglas predeterminadas para etiquetar recursos. En Terraform, se puede hacer uso de default_tags para garantizar que todos los recursos tengan un conjunto común de etiquetas.

```hcl
provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      AC       = "ES0063/ES990013/A200/C300"
      Producto = "SMART"
      Entorno  = "PROD"
      País     = "ES"
      PBI      = ""
    }
  }
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "main"
    Creado = "11/09/24"
    Modificado = "11/09/24"
  }
}
```

En este ejemplo, las etiquetas definidas en default_tags se aplicarán automáticamente a todos los recursos gestionados por Terraform en la región especificada, además se añade al recurso 'aws_vpc' tres tags(de los cuales dos son los obligatorios), esto mismo se debería hacer para los otros recursos.

Para más información sobre cómo gestionar las etiquetas en AWS utilizando Terraform, puedes consultar la [documentación](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) oficial.

## AZURE

En Azure, el enfoque del tagging está más enfocado a la gestión de grupos de recursos (resource groups). Existen dos políticas principales configuradas para la gestión de etiquetas en Azure:

- Política de obligatoriedad de tags: Esta política asegura que todos los recursos creados en Azure tengan las etiquetas requeridas. Si un recurso no contiene los tags obligatorios, no se permitirá su creación.
- Política de herencia de tags: Esta política permite que los recursos hereden automáticamente las etiquetas de su grupo de recursos. Esto simplifica la gestión, ya que solo es necesario aplicar las etiquetas al grupo de recursos, y todos los recursos bajo este grupo heredan las etiquetas definidas.

Consideraciones:

- Si se desea añadir etiquetas adicionales a un recurso específico, esto es posible. No se sobrescribirán las etiquetas heredadas mientras no sean las mismas.
- Es una buena práctica aplicar los tags en el nivel de grupo de recursos para asegurar consistencia en toda la infraestructura asociada.

```hcl
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"

  tags = {
    AC       = "ES0063/ES990013/A200/C300"
    Producto = "CRA"
    Entorno  = "PROD"
    País     = "ES"
    PBI      = ""
  }
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    Creado = "11/09/24"
    Modificado = "11/09/24"
  }
}
```

Al aplicar etiquetas a nivel de azurerm_resource_group, todos los recursos creados bajo este grupo heredarán las etiquetas especificadas.
