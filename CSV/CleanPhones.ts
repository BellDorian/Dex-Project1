// Cleans phone numbers stored in historical CSV record
// Assumes the first 10 digits found in the string are the digits of the phone number
// Enforces format ###-###-####
// Only processes the first 17 chars of a string, since this is the length of the longest acceptable format
// That is, (###) - ### - ####

function CleanPhones(p: string): string | null {
  let phoneNumber: string = "";
  const limit = p.length > 17 ? 17 : p.length;
  let index = 0;
  let count = 0;

  // Step 1. Find the area code numbers
  while (index < limit && count < 3) {
    const digit = +p[index];
    if (Number.isInteger(digit)) {
      phoneNumber += digit;
      count++;
    }
    index++;
  }
  phoneNumber += "-";

  // Step 2. Find the 3 middle numbers
  while (index < limit && count < 6) {
    const digit = +p[index];
    if (Number.isInteger(digit)) {
      phoneNumber += digit;
      count++;
    }
    index++;
  }
  phoneNumber += "-";

  // Step 3. Find the final 4 numbers of the phone number
  while (index < limit && count < 10) {
    const digit = +p[index];
    if (Number.isInteger(digit)) {
      phoneNumber += digit;
      count++;
    }
    index++;
  }

  // return as ###-###-####
  return phoneNumber.length === 12 ? phoneNumber : null;
}
