<!---
Markdown description for SystemRDL register map.

Don't override. Generated from: axi_bus_err_unit
  - rdl/axi_bus_err_unit.rdl
-->

## axi_bus_err_unit address map

- Absolute Address: 0x0
- Base Offset: 0x0
- Size: 0x30

|Offset|  Identifier  |Name|
|------|--------------|----|
| 0x00 |write_err_unit|  — |
| 0x20 | read_err_unit|  — |

## write_err_unit address map

- Absolute Address: 0x0
- Base Offset: 0x0
- Size: 0x10

|Offset| Identifier |Name|
|------|------------|----|
|  0x0 |  err_addr  |  — |
|  0x4 |err_addr_top|  — |
|  0x8 |  err_code  |  — |
|  0xC |    meta    |  — |

### err_addr register

- Absolute Address: 0x0
- Base Offset: 0x0
- Size: 0x4

|Bits|Identifier|Access|Reset|  Name  |
|----|----------|------|-----|--------|
|31:0| err_addr |   r  | 0x0 |err_addr|

#### err_addr field

<p>Address of the bus error</p>

### err_addr_top register

- Absolute Address: 0x4
- Base Offset: 0x4
- Size: 0x4

|Bits| Identifier |Access|Reset|    Name    |
|----|------------|------|-----|------------|
|31:0|err_addr_top|   r  | 0x0 |err_addr_top|

#### err_addr_top field

<p>Top of the address of the bus error</p>

### err_code register

- Absolute Address: 0x8
- Base Offset: 0x8
- Size: 0x4

|Bits|Identifier|Access|Reset|  Name  |
|----|----------|------|-----|--------|
|31:0| err_code |   r  | 0x0 |err_code|

#### err_code field

<p>Type of the bus error</p>

### meta register

- Absolute Address: 0xC
- Base Offset: 0xC
- Size: 0x4

|Bits|Identifier|Access|Reset|Name|
|----|----------|------|-----|----|
|31:0|   meta   |   r  | 0x0 |meta|

#### meta field

<p>Meta information of the bus error</p>

## read_err_unit address map

- Absolute Address: 0x20
- Base Offset: 0x20
- Size: 0x10

|Offset| Identifier |Name|
|------|------------|----|
|  0x0 |  err_addr  |  — |
|  0x4 |err_addr_top|  — |
|  0x8 |  err_code  |  — |
|  0xC |    meta    |  — |

### err_addr register

- Absolute Address: 0x20
- Base Offset: 0x0
- Size: 0x4

|Bits|Identifier|Access|Reset|  Name  |
|----|----------|------|-----|--------|
|31:0| err_addr |   r  | 0x0 |err_addr|

#### err_addr field

<p>Address of the bus error</p>

### err_addr_top register

- Absolute Address: 0x24
- Base Offset: 0x4
- Size: 0x4

|Bits| Identifier |Access|Reset|    Name    |
|----|------------|------|-----|------------|
|31:0|err_addr_top|   r  | 0x0 |err_addr_top|

#### err_addr_top field

<p>Top of the address of the bus error</p>

### err_code register

- Absolute Address: 0x28
- Base Offset: 0x8
- Size: 0x4

|Bits|Identifier|Access|Reset|  Name  |
|----|----------|------|-----|--------|
|31:0| err_code |   r  | 0x0 |err_code|

#### err_code field

<p>Type of the bus error</p>

### meta register

- Absolute Address: 0x2C
- Base Offset: 0xC
- Size: 0x4

|Bits|Identifier|Access|Reset|Name|
|----|----------|------|-----|----|
|31:0|   meta   |   r  | 0x0 |meta|

#### meta field

<p>Meta information of the bus error</p>
