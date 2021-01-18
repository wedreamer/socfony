import { NanoID } from '~deps';

/**
 * create [a-Z0-9-_] Nano ID.
 * @param length need create size.
 */
export function nanoIdGenerator(length: number): string {
  return NanoID.nanoid(length);
}

/**
 * Crate only number(0-9) Nano ID.
 * @param length need create size.
 */
export function numberNanoIdGenerator(length: number): string {
  return NanoID.customAlphabet('1234567890', length)();
}

/**
 * Crate only alphabet(A-Z) Nano ID.
 * @param length need create size.
 */
export function alphabetNanoIdGenerator(length: number): string {
  return NanoID.customAlphabet(
    'qwertyuiopasdfghjklzxcvbnm'.toUpperCase(),
    length,
  )();
}

/**
 * Crate only [23456789qwertyupasdfghjklzxcvbnm] Nano ID.
 * @param length need create size.
 */
export function readabilityNanoIdGenerator(length: number): string {
  return NanoID.customAlphabet(
    '23456789qwertyupasdfghjklzxcvbnm'.toUpperCase(),
    length,
  )();
}
