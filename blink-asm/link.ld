MEMORY {
  ROM (rx)     : ORIGIN = 0xC000, LENGTH = 0x3FDE
  VECTORS_RST  : ORIGIN = 0xFFFE, LENGTH = 0x0002
}

SECTIONS
{
  .reset :
  {
    KEEP (*(.reset))
  } > VECTORS_RST

  .text :
  {
    . = ALIGN(2);
    KEEP (*(.init))
    KEEP (*(.text))
  } > ROM
}
