#ifndef HAVE_BITOPS_H
#define HAVE_BITOPS_H

#define SET_BIT(ptr, byte, bit) (((char*)ptr)[byte] |= (1 << bit))
#define CLEAR_BIT(ptr, byte, bit) (((char*)ptr)[byte] &= ~(1 << bit))
#define GET_BIT(ptr, byte, bit) (((char*)ptr)[byte] & (1 << bit))
#define TOGGLE_BIT(ptr, byte, bit) (((char*)ptr)[byte] ^= (1 << bit))

#endif
