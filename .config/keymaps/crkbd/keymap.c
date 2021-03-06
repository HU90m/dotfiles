#include QMK_KEYBOARD_H

// US to UK
#define UK_AT   KC_DQUO
#define UK_DQUO KC_AT
#define UK_TILD KC_PIPE
#define UK_HASH KC_BSLS
#define UK_PIPE LSFT(KC_NUBS)
#define UK_EURO RALT(KC_4)
#define UK_PND  KC_HASH

// Layer Keys
#define LA2_TAB LT(LAY_LA2, KC_TAB)
#define LI2_TAB LT(LAY_LI2, KC_TAB)
#define LC3_ENT LT(LAY_LC3, KC_ENT)

#define TT_LI2  TT(LAY_LI2)
#define TT_LA2  TT(LAY_LA2)

#define MO_LC6  MO(LAY_LC6)
#define MO_LC8  MO(LAY_LC8)

#define DF_LC7  DF(LAY_LC7)
#define DF_LA1  DF(LAY_LA1)
#define DF_LI1  DF(LAY_LI1)
#define DF_LC5  DF(LAY_LC5)

// Mod Tap Keys
#define SFT_ESC LSFT_T(KC_ESC)
#define CTL_SPC LCTL_T(KC_SPC)
#define ALT_TAB LALT_T(KC_TAB)

// Misc Keys
#define SFT_GUI SGUI(KC_NO)
#define CTL_ALT LCA(KC_NO)
#define CURLY_R LSFT(KC_RBRC)
#define CURLY_L LSFT(KC_LBRC)


// Layers
enum layer_names {
  LAY_LI1, //    ISO Layer 1 (qwerty)
  LAY_LI2, //    ISO Layer 2 (symbols and numbers)
  LAY_LA1, //   ANSI Layer 1 (qwerty)
  LAY_LA2, //   ANSI Layer 2 (symbols and numbers)
  LAY_LC3, // Common Layer 3 (navigation)
  LAY_LC5, // Common Layer 5 (normal layout like)
  LAY_LC6, // Common Layer 6 (lowered numbers for normal layout like)
  LAY_LC7, // Common Layer 7 (for selecting default layer)
  LAY_LC8, // Common Layer 8 (numpad)
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [LAY_LI1] = LAYOUT( \
  //,-----------------------------------------------------.                    ,-----------------------------------------------------.
       DF_LC7,    KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,                         KC_Y,    KC_U,    KC_I,    KC_O,   KC_P,  KC_NUHS,\
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      KC_LGUI,    KC_A,    KC_S,    KC_D,    KC_F,    KC_G,                         KC_H,    KC_J,    KC_K,    KC_L, KC_SCLN, KC_QUOT,\
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      SFT_GUI,    KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,                         KC_N,    KC_M, KC_COMM,  KC_DOT, KC_SLSH, KC_NUBS,\
  //|--------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
                                           MO_LC8,  TT_LI2, SFT_ESC,    CTL_SPC, LC3_ENT, ALT_TAB \
                                      //`--------------------------'  `--------------------------'
  ),

  [LAY_LI2] = LAYOUT( \
  //,-----------------------------------------------------.                    ,-----------------------------------------------------.
       KC_GRV,   UK_AT, KC_EXLM, KC_LBRC, KC_RBRC, UK_PIPE,                      KC_ASTR,    KC_7,    KC_8,    KC_9, KC_MINS, UK_EURO,\
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      KC_LGUI, KC_AMPR, KC_UNDS, KC_LPRN, KC_RPRN, UK_DQUO,                      KC_PLUS,    KC_4,    KC_5,    KC_6,  KC_EQL,  KC_DLR,\
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      SFT_GUI,   KC_LT,   KC_GT, CURLY_L, CURLY_R, KC_CIRC,                         KC_0,    KC_1,    KC_2,    KC_3, KC_PERC,  UK_PND,\
  //|--------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
                                           MO_LC8, KC_TRNS, KC_LSFT,    CTL_SPC, KC_BSPC, ALT_TAB \
                                      //`--------------------------'  `--------------------------'
  ),

  [LAY_LA1] = LAYOUT( \
  //,-----------------------------------------------------.                    ,-----------------------------------------------------.
       DF_LC7,    KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,                         KC_Y,    KC_U,    KC_I,    KC_O,   KC_P,  KC_HASH,\
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      KC_LGUI,    KC_A,    KC_S,    KC_D,    KC_F,    KC_G,                         KC_H,    KC_J,    KC_K,    KC_L, KC_SCLN, KC_QUOT,\
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      SFT_GUI,    KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,                         KC_N,    KC_M, KC_COMM,  KC_DOT, KC_SLSH, KC_BSLS,\
  //|--------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
                                           MO_LC8,  TT_LA2, SFT_ESC,    CTL_SPC, LC3_ENT, ALT_TAB \
                                      //`--------------------------'  `--------------------------'
  ),

  [LAY_LA2] = LAYOUT( \
  //,-----------------------------------------------------.                    ,-----------------------------------------------------.
       KC_GRV,   KC_AT, KC_EXLM, KC_LBRC, KC_RBRC, KC_PIPE,                      KC_ASTR,    KC_7,    KC_8,    KC_9, KC_MINS, KC_TILD,\
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      KC_LGUI, KC_AMPR, KC_UNDS, KC_LPRN, KC_RPRN, KC_DQUO,                      KC_PLUS,    KC_4,    KC_5,    KC_6,  KC_EQL,  KC_DLR,\
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      SFT_GUI,   KC_LT,   KC_GT, CURLY_L, CURLY_R, KC_CIRC,                         KC_0,    KC_1,    KC_2,    KC_3, KC_PERC,   KC_NO,\
  //|--------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
                                           MO_LC8, KC_TRNS, KC_LSFT,    CTL_SPC, KC_BSPC, ALT_TAB \
                                      //`--------------------------'  `--------------------------'
  ),

  [LAY_LC3] = LAYOUT( \
  //,-----------------------------------------------------.                    ,-----------------------------------------------------.
        KC_NO,   KC_NO,   KC_F7,   KC_F8,   KC_F9,  KC_F12,                        KC_NO,   KC_NO,   KC_NO,   KC_NO, KC_PSCR,   KC_NO,\
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      KC_LGUI, KC_CAPS,   KC_F4,   KC_F5,   KC_F6,  KC_F11,                      KC_LEFT, KC_DOWN,   KC_UP, KC_RGHT,  KC_DEL,   KC_NO,\
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      SFT_GUI,   KC_NO,   KC_F1,   KC_F2,   KC_F3,  KC_F10,                      KC_HOME, KC_PGDN, KC_PGUP,  KC_END,  KC_INS, CTL_ALT,\
  //|--------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
                                           MO_LC8,  KC_ESC,  KC_TAB,     KC_SPC, KC_TRNS, ALT_TAB \
                                      //`--------------------------'  `--------------------------'
  ),

  [LAY_LC5] = LAYOUT( \
  //,-----------------------------------------------------.                    ,-----------------------------------------------------.
       KC_TAB,    KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,                         KC_Y,    KC_U,    KC_I,    KC_O,   KC_P,  KC_BSPC,\
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      KC_CAPS,    KC_A,    KC_S,    KC_D,    KC_F,    KC_G,                         KC_H,    KC_J,    KC_K,    KC_L, KC_SCLN, KC_QUOT,\
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      KC_LSFT,    KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,                         KC_N,    KC_M, KC_COMM,  KC_DOT, KC_SLSH, KC_RSFT,\
  //|--------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
                                          KC_LCTL,  MO_LC6,  KC_SPC,     KC_SPC,  KC_ENT,  DF_LC7 \
                                      //`--------------------------'  `--------------------------'
  ),

  [LAY_LC6] = LAYOUT( \
  //,-----------------------------------------------------.                    ,-----------------------------------------------------.
       KC_ESC,    KC_1,    KC_2,    KC_3,    KC_4,    KC_5,                         KC_6,    KC_7,    KC_8,    KC_9,    KC_0, KC_BSPC,\
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      KC_CAPS,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,                      KC_LEFT, KC_DOWN,   KC_UP, KC_RGHT,   KC_NO,   KC_NO,\
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
      KC_LSFT,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,                        KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,\
  //|--------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
                                          KC_LCTL, KC_TRNS,  KC_SPC,     KC_SPC,  KC_ENT,   KC_NO \
                                      //`--------------------------'  `--------------------------'
  ),

  [LAY_LC7] = LAYOUT( \
  //,-----------------------------------------------------.                    ,-----------------------------------------------------.
        KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,                        KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,\
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
        KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,                        KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,\
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
        KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,                        KC_NO,  DF_LI1,  DF_LA1,  DF_LC5,   KC_NO,   KC_NO,\
  //|--------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
                                            KC_NO,   KC_NO,   KC_NO,      KC_NO,   KC_NO,   KC_NO \
                                      //`--------------------------'  `--------------------------'
  ),

  [LAY_LC8] = LAYOUT( \
  //,-----------------------------------------------------.                    ,-----------------------------------------------------.
        KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,                      KC_PAST,   KC_P7,   KC_P8,   KC_P9, KC_PMNS, KC_NLCK,\
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
        KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,                      KC_PPLS,   KC_P4,   KC_P5,   KC_P6, KC_PEQL, KC_PCMM,\
  //|--------+--------+--------+--------+--------+--------|                    |--------+--------+--------+--------+--------+--------|
        KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,   KC_NO,                        KC_P0,   KC_P1,   KC_P2,   KC_P3, KC_PSLS, KC_PDOT,\
  //|--------+--------+--------+--------+--------+--------+--------|  |--------+--------+--------+--------+--------+--------+--------|
                                          KC_TRNS,   KC_NO,   KC_NO,     KC_SPC, KC_PENT,   KC_NO \
                                      //`--------------------------'  `--------------------------'
  ),
};
