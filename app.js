const JURISDICTIONS = [
  { name: 'Alabama', code: 'AL', country: 'USA' },
  { name: 'Alaska', code: 'AK', country: 'USA' },
  { name: 'Arizona', code: 'AZ', country: 'USA' },
  { name: 'Arkansas', code: 'AR', country: 'USA' },
  { name: 'California', code: 'CA', country: 'USA' },
  { name: 'Colorado', code: 'CO', country: 'USA' },
  { name: 'Connecticut', code: 'CT', country: 'USA' },
  { name: 'Delaware', code: 'DE', country: 'USA' },
  { name: 'District of Columbia', code: 'DC', country: 'USA' },
  { name: 'Florida', code: 'FL', country: 'USA' },
  { name: 'Georgia', code: 'GA', country: 'USA' },
  { name: 'Hawaii', code: 'HI', country: 'USA' },
  { name: 'Idaho', code: 'ID', country: 'USA' },
  { name: 'Illinois', code: 'IL', country: 'USA' },
  { name: 'Indiana', code: 'IN', country: 'USA' },
  { name: 'Iowa', code: 'IA', country: 'USA' },
  { name: 'Kansas', code: 'KS', country: 'USA' },
  { name: 'Kentucky', code: 'KY', country: 'USA' },
  { name: 'Louisiana', code: 'LA', country: 'USA' },
  { name: 'Maine', code: 'ME', country: 'USA' },
  { name: 'Maryland', code: 'MD', country: 'USA' },
  { name: 'Massachusetts', code: 'MA', country: 'USA' },
  { name: 'Michigan', code: 'MI', country: 'USA' },
  { name: 'Minnesota', code: 'MN', country: 'USA' },
  { name: 'Mississippi', code: 'MS', country: 'USA' },
  { name: 'Missouri', code: 'MO', country: 'USA' },
  { name: 'Montana', code: 'MT', country: 'USA' },
  { name: 'Nebraska', code: 'NE', country: 'USA' },
  { name: 'Nevada', code: 'NV', country: 'USA' },
  { name: 'New Hampshire', code: 'NH', country: 'USA' },
  { name: 'New Jersey', code: 'NJ', country: 'USA' },
  { name: 'New Mexico', code: 'NM', country: 'USA' },
  { name: 'New York', code: 'NY', country: 'USA' },
  { name: 'North Carolina', code: 'NC', country: 'USA' },
  { name: 'North Dakota', code: 'ND', country: 'USA' },
  { name: 'Ohio', code: 'OH', country: 'USA' },
  { name: 'Oklahoma', code: 'OK', country: 'USA' },
  { name: 'Oregon', code: 'OR', country: 'USA' },
  { name: 'Pennsylvania', code: 'PA', country: 'USA' },
  { name: 'Rhode Island', code: 'RI', country: 'USA' },
  { name: 'South Carolina', code: 'SC', country: 'USA' },
  { name: 'South Dakota', code: 'SD', country: 'USA' },
  { name: 'Tennessee', code: 'TN', country: 'USA' },
  { name: 'Texas', code: 'TX', country: 'USA' },
  { name: 'Utah', code: 'UT', country: 'USA' },
  { name: 'Vermont', code: 'VT', country: 'USA' },
  { name: 'Virginia', code: 'VA', country: 'USA' },
  { name: 'Washington', code: 'WA', country: 'USA' },
  { name: 'West Virginia', code: 'WV', country: 'USA' },
  { name: 'Wisconsin', code: 'WI', country: 'USA' },
  { name: 'Wyoming', code: 'WY', country: 'USA' },
  { name: 'Alberta', code: 'AB', country: 'CAN' },
  { name: 'British Columbia', code: 'BC', country: 'CAN' },
  { name: 'Manitoba', code: 'MB', country: 'CAN' },
  { name: 'New Brunswick', code: 'NB', country: 'CAN' },
  { name: 'Newfoundland and Labrador', code: 'NL', country: 'CAN' },
  { name: 'Nova Scotia', code: 'NS', country: 'CAN' },
  { name: 'Ontario', code: 'ON', country: 'CAN' },
  { name: 'Prince Edward Island', code: 'PE', country: 'CAN' },
  { name: 'Quebec', code: 'QC', country: 'CAN' },
  { name: 'Saskatchewan', code: 'SK', country: 'CAN' },
  { name: 'Northwest Territories', code: 'NT', country: 'CAN' },
  { name: 'Nunavut', code: 'NU', country: 'CAN' },
  { name: 'Yukon', code: 'YT', country: 'CAN' }
];

const COUNTRIES = [
  { value: 'USA', label: 'United States' },
  { value: 'CAN', label: 'Canada' },
  { value: 'MEX', label: 'Mexico' },
  { value: 'AUS', label: 'Australia' },
  { value: 'GBR', label: 'United Kingdom' },
  { value: 'DEU', label: 'Germany' },
  { value: 'FRA', label: 'France' },
  { value: 'JPN', label: 'Japan' },
  { value: 'AUT', label: 'Austria' },
  { value: 'BEL', label: 'Belgium' },
  { value: 'BRA', label: 'Brazil' },
  { value: 'CHN', label: 'China' },
  { value: 'DNK', label: 'Denmark' },
  { value: 'ESP', label: 'Spain' },
  { value: 'FIN', label: 'Finland' },
  { value: 'IRL', label: 'Ireland' },
  { value: 'ISR', label: 'Israel' },
  { value: 'IND', label: 'India' },
  { value: 'ITA', label: 'Italy' },
  { value: 'KOR', label: 'South Korea' },
  { value: 'NLD', label: 'Netherlands' },
  { value: 'NZL', label: 'New Zealand' },
  { value: 'PHL', label: 'Philippines' },
  { value: 'SWE', label: 'Sweden' },
  { value: 'SGP', label: 'Singapore' },
  { value: 'ZAF', label: 'South Africa' }
];

const GENDERS = [
  { value: '0', label: 'Not specified' },
  { value: '1', label: 'Male' },
  { value: '2', label: 'Female' },
  { value: '9', label: 'Non-binary' }
];

const EYE_COLORS = [
  { value: 'AMB', label: 'Amber' },
  { value: 'BKL', label: 'Black' },
  { value: 'BLU', label: 'Blue' },
  { value: 'BRO', label: 'Brown' },
  { value: 'DIC', label: 'Dichromatic' },
  { value: 'GRN', label: 'Green' },
  { value: 'GRY', label: 'Gray' },
  { value: 'HAZ', label: 'Hazel' },
  { value: 'MAR', label: 'Maroon' },
  { value: 'PNK', label: 'Pink' },
  { value: 'UNK', label: 'Unknown' }
];

const STORAGE_KEY = 'dlbg-form-state-v1';
const DATA_ELEMENT_SEPARATOR = '\n';
const RECORD_SEPARATOR = '\u001E';
const SEGMENT_TERMINATOR = '\r';
const FILE_TYPE = 'ANSI ';
const SUBFILE_DESCRIPTOR_LENGTH = 10;

function createDefaultState() {
  const today = new Date();
  const expiration = new Date(today);
  expiration.setFullYear(expiration.getFullYear() + 4);
  const dob = new Date(today);
  dob.setFullYear(dob.getFullYear() - 30);

  return {
    iin: '636000',
    aamvaVersion: '08',
    jurisdictionVersion: '00',
    subfileType: 'DL',
    documentDiscriminator: randomDiscriminator(),
    customerId: '',
    issueDate: formatInputDate(today),
    expirationDate: formatInputDate(expiration),
    firstName: '',
    middleName: '',
    lastName: '',
    dateOfBirth: formatInputDate(dob),
    gender: '0',
    eyeColor: 'HAZ',
    height: '',
    heightOutputUnit: 'imperial',
    addressLine1: '',
    addressLine2: '',
    city: '',
    jurisdiction: 'OH',
    country: 'USA',
    postalCode: '',
    vehicleClass: '',
    restrictionCodes: '',
    endorsementCodes: '',
    barcodeScale: 6
  };
}

const form = document.getElementById('license-form');
const errorsEl = document.getElementById('form-errors');
const scaleInput = document.getElementById('barcode-scale');
const scaleValue = document.getElementById('scale-value');
const canvas = document.getElementById('barcode-canvas');
const payloadOutput = document.getElementById('payload-output');
const downloadButton = document.getElementById('download-png');
const copyButton = document.getElementById('copy-payload');
const resetButton = document.getElementById('reset-form');
const discriminatorButton = document.getElementById('regenerate-discriminator');

init();

function init() {
  populateOptions();
  restoreState();
  form.addEventListener('submit', handleSubmit);
  form.addEventListener('input', debounce(() => saveState(), 300));
  scaleInput.addEventListener('input', () => {
    scaleValue.textContent = `${scaleInput.value}×`;
    saveState();
  });
  downloadButton.addEventListener('click', handleDownload);
  copyButton.addEventListener('click', handleCopyPayload);
  resetButton.addEventListener('click', resetForm);
  discriminatorButton.addEventListener('click', () => {
    document.getElementById('document-discriminator').value = randomDiscriminator();
    saveState();
  });
  document.getElementById('jurisdiction').addEventListener('change', syncCountryWithJurisdiction);
}

function populateOptions() {
  const jurisdictionSelect = document.getElementById('jurisdiction');
  jurisdictionSelect.innerHTML = '';
  JURISDICTIONS.sort((a, b) => a.name.localeCompare(b.name)).forEach((j) => {
    const option = document.createElement('option');
    option.value = j.code;
    option.textContent = `${j.name} (${j.code})`;
    option.dataset.country = j.country;
    jurisdictionSelect.append(option);
  });

  const countrySelect = document.getElementById('country');
  countrySelect.innerHTML = '';
  COUNTRIES.sort((a, b) => a.label.localeCompare(b.label)).forEach((c) => {
    const option = document.createElement('option');
    option.value = c.value;
    option.textContent = `${c.label} (${c.value})`;
    countrySelect.append(option);
  });

  const genderSelect = document.getElementById('gender');
  genderSelect.innerHTML = '';
  GENDERS.forEach((g) => {
    const option = document.createElement('option');
    option.value = g.value;
    option.textContent = g.label;
    genderSelect.append(option);
  });

  const eyeColorSelect = document.getElementById('eye-color');
  eyeColorSelect.innerHTML = '';
  EYE_COLORS.forEach((color) => {
    const option = document.createElement('option');
    option.value = color.value;
    option.textContent = color.label;
    eyeColorSelect.append(option);
  });
}

function restoreState() {
  const saved = getSavedState();
  const defaults = createDefaultState();
  const state = { ...defaults, ...saved };
  const hasSavedCountry = Object.prototype.hasOwnProperty.call(saved, 'country');

  Object.entries(state).forEach(([key, value]) => {
    const field = document.getElementById(toInputId(key));
    if (!field) return;
    if (field.type === 'checkbox') {
      field.checked = Boolean(value);
    } else {
      field.value = value;
    }
  });
  scaleValue.textContent = `${scaleInput.value}×`;
  if (!hasSavedCountry) {
    syncCountryWithJurisdiction();
  }
}

function getSavedState() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    return raw ? JSON.parse(raw) : {};
  } catch (error) {
    console.warn('Unable to load saved form state', error);
    return {};
  }
}

function saveState() {
  const state = serializeForm();
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
  } catch (error) {
    console.warn('Unable to persist form state', error);
  }
}

function serializeForm() {
  const formData = new FormData(form);
  const entries = Object.fromEntries(formData.entries());
  entries['barcode-scale'] = scaleInput.value;
  return entries;
}

function handleSubmit(event) {
  event.preventDefault();
  const formValues = serializeForm();
  const { dataElements, errors, config } = buildDataElements(formValues);

  if (errors.length > 0) {
    displayErrors(errors);
    return;
  }

  clearErrors();
  const payload = dataElements.join(DATA_ELEMENT_SEPARATOR);
  const subfileData = `${config.subfileType}${payload}`;
  const header = buildHeader(config, 1);
  const descriptor = buildSubfileDescriptor(config.subfileType, header.length + SUBFILE_DESCRIPTOR_LENGTH, subfileData.length);
  const barcodePayload = `${header}${descriptor}${subfileData}`;

  if (!/^[\x00-\x7F]*$/.test(barcodePayload)) {
    displayErrors(['The generated payload contains non-ASCII characters. Please remove accents or special characters.']);
    return;
  }

  payloadOutput.value = barcodePayload;
  drawBarcode(barcodePayload, Number(formValues['barcode-scale'] || 6));
  saveState();
}

function buildDataElements(values) {
  const errors = [];
  const config = {
    issuerIdentificationNumber: values['iin']?.trim() ?? '',
    aamvaVersionNumber: values['aamva-version']?.trim() ?? '',
    jurisdictionVersionNumber: values['jurisdiction-version']?.trim() ?? '',
    subfileType: values['subfile-type'] || 'DL'
  };

  if (!/^[0-9]{6}$/.test(config.issuerIdentificationNumber)) {
    errors.push('Issuer Identification Number must be exactly six digits.');
  }
  if (!/^[0-9]{2}$/.test(config.aamvaVersionNumber)) {
    errors.push('AAMVA version must be a two-digit number.');
  }
  if (!/^[0-9]{2}$/.test(config.jurisdictionVersionNumber)) {
    errors.push('Jurisdiction version must be a two-digit number.');
  }

  const firstName = values['first-name'] ?? '';
  const middleName = values['middle-name'] ?? '';
  const lastName = values['last-name'] ?? '';
  const firstFormatted = formatName(firstName, 40);
  const middleFormatted = formatName(middleName, 40);
  const lastFormatted = formatName(lastName, 40);

  if (!firstFormatted) {
    errors.push('First name is required.');
  }
  if (!lastFormatted) {
    errors.push('Last name is required.');
  }

  const issueDate = parseDate(values['issue-date']);
  const expirationDate = parseDate(values['expiration-date']);
  const dateOfBirth = parseDate(values['date-of-birth']);

  if (!issueDate) {
    errors.push('Issue date is required.');
  }
  if (!expirationDate) {
    errors.push('Expiration date is required.');
  }
  if (!dateOfBirth) {
    errors.push('Date of birth is required.');
  }
  if (issueDate && expirationDate && expirationDate <= issueDate) {
    errors.push('Expiration date must be after the issue date.');
  }

  const addressLine1 = formatStreet(values['address-line1'] ?? '', 40);
  const addressLine2 = formatStreet(values['address-line2'] ?? '', 40);
  const city = formatCity(values['city'] ?? '', 40);
  if (!addressLine1) {
    errors.push('Address line 1 is required.');
  }
  if (!city) {
    errors.push('City is required.');
  }

  const jurisdiction = values['jurisdiction'] ?? '';
  if (!jurisdiction) {
    errors.push('Jurisdiction must be selected.');
  }

  const postalCodeFormatted = formatPostalCode(values['postal-code'] ?? '');
  if (!postalCodeFormatted) {
    errors.push('Enter a valid postal code.');
  }

  const customerId = formatAlphanumeric(values['customer-id'] ?? '', 25);
  if (!customerId) {
    errors.push('Customer ID / License number is required.');
  }

  const documentDiscriminator =
    formatAlphanumeric(values['document-discriminator'] ?? '', 25) || randomDiscriminator();
  const gender = values['gender'] || '0';
  const eyeColor = values['eye-color'] || 'UNK';

  const heightResult = parseHeight(values['height'] ?? '');
  const heightOutputUnit = values['height-output-unit'] || 'imperial';
  if (values['height'] && !heightResult) {
    errors.push('Height must be provided in inches (e.g., 70 in), feet/inches (e.g., 5\'11"), or centimeters.');
  }

  const heightFormatted = formatHeight(heightResult ?? 0, heightOutputUnit === 'metric');

  const country = values['country'] || inferCountryFromJurisdiction(jurisdiction) || 'USA';

  const truncFirst = truncationStatus(sanitizeName(firstName), 40);
  const truncMiddle = truncationStatus(sanitizeName(middleName), 40);
  const truncLast = truncationStatus(sanitizeName(lastName), 40);

  const vehicleClass = formatOptional(values['vehicle-class'] ?? '', 12);
  const restrictionCodes = formatOptional(values['restriction-codes'] ?? '', 12);
  const endorsementCodes = formatOptional(values['endorsement-codes'] ?? '', 12);

  syncSanitizedValue('customer-id', customerId);
  syncSanitizedValue('document-discriminator', documentDiscriminator);
  syncSanitizedValue('postal-code', postalCodeFormatted);
  syncSanitizedValue('vehicle-class', vehicleClass);
  syncSanitizedValue('restriction-codes', restrictionCodes);
  syncSanitizedValue('endorsement-codes', endorsementCodes);

  const dataElements = [
    `DAQ${customerId}`,
    `DCS${lastFormatted}`,
    `DAC${firstFormatted}`,
    `DAD${middleFormatted}`,
    issueDate ? `DBD${formatDate(issueDate)}` : '',
    dateOfBirth ? `DBB${formatDate(dateOfBirth)}` : '',
    expirationDate ? `DBA${formatDate(expirationDate)}` : '',
    `DBC${gender}`,
    `DAY${eyeColor}`,
    `DAU${heightFormatted}`,
    `DAG${addressLine1}`,
    addressLine2 ? `DAH${addressLine2}` : null,
    `DAI${city}`,
    `DAJ${jurisdiction}`,
    `DAK${postalCodeFormatted}`,
    `DCF${documentDiscriminator}`,
    `DCG${country}`,
    `DDE${truncLast}`,
    `DDF${truncFirst}`,
    `DDG${truncMiddle}`,
    `DCA${vehicleClass}`,
    `DCB${restrictionCodes}`,
    `DCD${endorsementCodes}`
  ].filter(Boolean);

  return { dataElements, errors, config };
}

function buildHeader(config, numberOfEntries) {
  return [
    '@',
    '\n',
    RECORD_SEPARATOR,
    SEGMENT_TERMINATOR,
    FILE_TYPE,
    config.issuerIdentificationNumber,
    config.aamvaVersionNumber,
    config.jurisdictionVersionNumber,
    numberOfEntries.toString().padStart(2, '0')
  ].join('');
}

function buildSubfileDescriptor(type, offset, length) {
  const offsetString = offset.toString().padStart(4, '0');
  const lengthString = length.toString().padStart(4, '0');
  return `${type}${offsetString}${lengthString}`;
}

function drawBarcode(payload, scale) {
  if (typeof bwipjs === 'undefined') {
    displayErrors(['Barcode renderer failed to load. Check your internet connection and try again.']);
    return;
  }

  try {
    bwipjs.toCanvas(canvas, {
      bcid: 'pdf417',
      text: payload,
      scale: Math.max(2, Math.min(scale, 12)),
      includetext: false,
      columns: 5,
      rows: 30,
      // Provide generous quiet zones
      padding: 20
    });
  } catch (error) {
    console.error(error);
    displayErrors(['Failed to render the barcode. Try adjusting the data or refreshing the page.']);
  }
}

function handleDownload() {
  const link = document.createElement('a');
  link.href = canvas.toDataURL('image/png');
  link.download = 'drivers-license-barcode.png';
  link.click();
}

async function handleCopyPayload() {
  if (!payloadOutput.value) return;
  try {
    await navigator.clipboard.writeText(payloadOutput.value);
    copyButton.textContent = 'Copied!';
    setTimeout(() => (copyButton.textContent = 'Copy Payload'), 2000);
  } catch (error) {
    console.warn('Clipboard unavailable', error);
    copyButton.textContent = 'Unable to copy';
    setTimeout(() => (copyButton.textContent = 'Copy Payload'), 2500);
  }
}

function resetForm() {
  localStorage.removeItem(STORAGE_KEY);
  const defaults = createDefaultState();
  Object.entries(defaults).forEach(([key, value]) => {
    const field = document.getElementById(toInputId(key));
    if (!field) return;
    field.value = value;
  });
  scaleInput.value = defaults.barcodeScale;
  scaleValue.textContent = `${scaleInput.value}×`;
  payloadOutput.value = '';
  const ctx = canvas.getContext('2d');
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  clearErrors();
}

function syncCountryWithJurisdiction() {
  const jurisdictionSelect = document.getElementById('jurisdiction');
  const countryField = document.getElementById('country');
  const selected = jurisdictionSelect.selectedOptions[0];
  if (selected && selected.dataset.country) {
    countryField.value = selected.dataset.country;
  }
}

function displayErrors(messages) {
  errorsEl.hidden = false;
  errorsEl.innerHTML = messages.map((msg) => `<p>${msg}</p>`).join('');
}

function clearErrors() {
  errorsEl.hidden = true;
  errorsEl.innerHTML = '';
}

function syncSanitizedValue(id, value) {
  const field = document.getElementById(id);
  if (!field || typeof value !== 'string') {
    return;
  }
  if (field.value !== value) {
    field.value = value;
  }
}

function formatDate(date) {
  const month = String(date.getUTCMonth() + 1).padStart(2, '0');
  const day = String(date.getUTCDate()).padStart(2, '0');
  const year = date.getUTCFullYear();
  return `${month}${day}${year}`;
}

function parseDate(value) {
  if (!value) return null;
  const normalized = `${value}T00:00:00`;
  const date = new Date(normalized);
  return Number.isNaN(date.getTime()) ? null : date;
}

function formatInputDate(date) {
  const month = String(date.getUTCMonth() + 1).padStart(2, '0');
  const day = String(date.getUTCDate()).padStart(2, '0');
  return `${date.getUTCFullYear()}-${month}-${day}`;
}

function randomDiscriminator() {
  if (typeof crypto !== 'undefined' && typeof crypto.randomUUID === 'function') {
    return crypto.randomUUID().replace(/-/g, '').slice(0, 25).toUpperCase();
  }
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let result = '';
  for (let i = 0; i < 25; i += 1) {
    const index = Math.floor(Math.random() * chars.length);
    result += chars[index];
  }
  return result;
}

function formatName(value, length) {
  return sanitize(value, NAME_ALLOWED, length, { collapseWhitespace: true });
}

function sanitizeName(value) {
  return sanitize(value, NAME_ALLOWED, 100, { collapseWhitespace: true });
}

function formatStreet(value, length) {
  return sanitize(value, ADDRESS_ALLOWED, length, { collapseWhitespace: true });
}

function formatCity(value, length) {
  return sanitize(value, CITY_ALLOWED, length, { collapseWhitespace: true });
}

function formatAlphanumeric(value, length) {
  return sanitize(value, ALPHANUMERIC_ALLOWED, length, { collapseWhitespace: false });
}

function formatOptional(value, length) {
  return sanitize(value, DEFAULT_ALLOWED, length, { collapseWhitespace: true });
}

function formatPostalCode(value) {
  const trimmed = value.trim().toUpperCase();
  if (!trimmed) return '';
  const filtered = trimmed.replace(/[^0-9A-Z]/g, '');
  if (!filtered) return '';
  if (/^[0-9]+$/.test(filtered)) {
    return filtered.padEnd(9, '0').slice(0, 9);
  }
  return filtered.slice(0, 11);
}

function formatHeight(inches, useMetric) {
  if (!inches || inches <= 0) return '';
  if (useMetric) {
    const centimeters = Math.round(inches * 2.54);
    return `${String(centimeters).padStart(3, '0')} CM`;
  }
  return `${String(inches).padStart(3, '0')} IN`;
}

function parseHeight(value) {
  const trimmed = value.trim();
  if (!trimmed) return null;
  const normalized = trimmed.toLowerCase();

  const cmMatch = normalized.match(/([0-9]+(?:\.[0-9]+)?)\s*cm/);
  if (cmMatch) {
    const centimeters = parseFloat(cmMatch[1]);
    if (!Number.isNaN(centimeters) && centimeters > 0) {
      return Math.round(centimeters / 2.54);
    }
    return null;
  }

  const inchMatch = normalized.match(/([0-9]+(?:\.[0-9]+)?)\s*in/);
  if (inchMatch) {
    const inches = parseFloat(inchMatch[1]);
    return !Number.isNaN(inches) ? Math.round(inches) : null;
  }

  const ftInMatch = normalized.match(/([0-9]+)\s*(?:ft|feet|')\s*(?:([0-9]+)\s*(?:in|inches|"))?/);
  if (ftInMatch) {
    const feet = parseInt(ftInMatch[1], 10);
    const inches = ftInMatch[2] ? parseInt(ftInMatch[2], 10) : 0;
    if (!Number.isNaN(feet) && feet >= 0 && inches >= 0) {
      return feet * 12 + inches;
    }
  }

  if (/^[0-9]+$/.test(normalized)) {
    const numeric = parseInt(normalized, 10);
    if (numeric > 140) {
      return Math.round(numeric / 2.54);
    }
    if (numeric > 36) {
      return numeric;
    }
  }

  return null;
}

const DEFAULT_ALLOWED = new Set('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 \u0027-.,&/');
const NAME_ALLOWED = new Set('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 \u0027-.');
const CITY_ALLOWED = new Set('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 \u0027-.');
const ADDRESS_ALLOWED = new Set("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 '#&.,-/ ");
const ALPHANUMERIC_ALLOWED = new Set('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789');

function sanitize(value, allowedSet, length, { collapseWhitespace }) {
  const trimmed = (value ?? '').toString().trim();
  if (!trimmed) return '';
  const normalized = trimmed
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toUpperCase();
  const collapsed = collapseWhitespace ? normalized.replace(/\s+/g, ' ') : normalized;
  let result = '';
  for (const char of collapsed) {
    if (allowedSet.has(char)) {
      result += char;
      if (length && result.length >= length) {
        return result.slice(0, length);
      }
    }
  }
  return length ? result.slice(0, length) : result;
}

function truncationStatus(value, limit) {
  if (!value) return 'N';
  return value.length > limit ? 'T' : 'N';
}

function inferCountryFromJurisdiction(code) {
  const match = JURISDICTIONS.find((j) => j.code === code);
  return match ? match.country : null;
}

function debounce(fn, wait) {
  let timeout;
  return (...args) => {
    clearTimeout(timeout);
    timeout = setTimeout(() => fn(...args), wait);
  };
}

function toInputId(key) {
  switch (key) {
    case 'iin':
      return 'iin';
    case 'aamvaVersion':
      return 'aamva-version';
    case 'jurisdictionVersion':
      return 'jurisdiction-version';
    case 'subfileType':
      return 'subfile-type';
    case 'documentDiscriminator':
      return 'document-discriminator';
    case 'customerId':
      return 'customer-id';
    case 'issueDate':
      return 'issue-date';
    case 'expirationDate':
      return 'expiration-date';
    case 'firstName':
      return 'first-name';
    case 'middleName':
      return 'middle-name';
    case 'lastName':
      return 'last-name';
    case 'dateOfBirth':
      return 'date-of-birth';
    case 'gender':
      return 'gender';
    case 'eyeColor':
      return 'eye-color';
    case 'height':
      return 'height';
    case 'heightOutputUnit':
      return 'height-output-unit';
    case 'addressLine1':
      return 'address-line1';
    case 'addressLine2':
      return 'address-line2';
    case 'city':
      return 'city';
    case 'jurisdiction':
      return 'jurisdiction';
    case 'country':
      return 'country';
    case 'postalCode':
      return 'postal-code';
    case 'vehicleClass':
      return 'vehicle-class';
    case 'restrictionCodes':
      return 'restriction-codes';
    case 'endorsementCodes':
      return 'endorsement-codes';
    case 'barcodeScale':
      return 'barcode-scale';
    default:
      return key;
  }
}
