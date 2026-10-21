<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>PROJECT V2.6 — Secure Script Workspace</title><meta name="description" content="PROJECT V2.6 local script workspace and key management. Your code. Your control."><meta property="og:title" content="PROJECT V2.6 — Script Protection"><meta property="og:description" content="Manage your scripts and access keys in the PROJECT V2.6 workspace."><meta property="og:type" content="website"><meta name="twitter:card" content="summary_large_image"><link rel="icon" type="image/png" href="data:image/png;base64,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7bd/C84hAc+rRLlUxPe//xCq1fVcLJagte4ODbqARKKnHhApA+RzeREGxwlAuhu7afFHBJEUXVuzGduJeqWKl1pF8u6phJ8/+gjuueceFAt5aK27vIKAtRZfvuLPsOSM9yKO24mHIVZKod1u49Zb12DhwgVotZogdER/92t7cO2110IFAYy1WRWas9Cns2GaSAL7egVBSoIGgE2bjk8C9ux5mZYte8zFLW2T0DKZIbvqxKZpbSopWBujEUY5Hh4exo4dLyGfz8EYkxhEQGuDnt4erL7+OhitIZVEEASo12u49NLL6LOf/Y9otdqJ1ffltDAMcP1112PXrp0cBIEvimY8UxdhlH34goJ/q93WTArNbcdwhceIAyqo1esubrdSnLsPOupvYtXTQGjfvr18zbXXIlCqU6pKIjitDS677DKcd96HqdlowDmHBQtOodtv/2b2HjN7sHpK+Ju/+SEe/O6DXCiWoOM4jYYBEE+li3kqgT5WqdVq0HWgr2/j8QEwNq/GADAxMelazaYvUqZVvq65uman7vtpqPvX1Soefng9yiVvEH1xlGGMgVIKN998E3K5POJ2jG9965vo7+/3AQ8RjLWIchH27d+PVatWQQrRvfLpZNncM25uMOCsRn2yxhOTsa1WwZVK5Tj2BbYCQMU1GjWndTtNdDoV0MzzZAa8e05iZlhjIKXka6+7Dvv27UcUhTDWZNIAALt27UKzWcfll19Olcqn0Wq1mQRloXIuCrF69Q144YXnOQhDctZimrnLaJjGlbcQ7Ng5i3q9homJthsCMDwDTjOowFYQETdqkxy3W77e78veU4VguhJ0Lsk6hyAI8dKOF3loaBi5KPL1QqORzxewffvzuOqqq3jx4tPoG99YA2MtHDtKrX5vTxk/+vFP8MD993OhUILWOinyMGXzJt+nU58uFTOTNQbNRp2PtJOukxkQmAYA057+fmZmarVqIm43/T5dyvPUSnjCNE2742+nzN5//3145GePYlZvj3eLzuCKK67A+PgY7rzzTpxwwglot2IABGstojDCgYMHsXLFShAROWfBjpFUzDtO2LvlmfSaUs9jrUGrUYOp1aZX3o8FAAGbvDtst7UxRnsL7riroWm6JGRWqesmJ7s3DtZZvnrVKoyNjWNWbxnfuv0v8POfP8pf+cpy+sM//AM0Gk2kom+tRT4fYfXqG7B9+28RRpF3e1PnTLzQUYtPXZrqATAacRzDMfNIRuRU0I6ZDbYaNXbWeBVAWmriFMIkeE2NI00nh4EkYwxz2Lz5WaxduxZbtmzF0I038PvefxaNjIwg9mks2HnjOau3B//7Rz/Gfffei3yhyDqOuVv1ulY8CbS7y1/JK9lOs2NrLayJ2ZgptbLXkwDwJviAga0ha9P0NuPY+1g/4/Tw+KgSLhjQOqYgCHnt2rX4xCc+AWsdvr12LXp6yvBFV3irH0XYv/8AVnxtBYiInS+HdW0KzHR0305yYgayPgJ20CZmJPPMZASOChFL2+alRVG2SU0u7QHIJkrrpFMEbkrRaNoTQq1e50OHDmJk5Ov04Q9/CJO1OgSlVt+ikC/hy1d8GS+8sJ0LhSJirVNQM6WfnvdOQ6UToXv5IMcORsfcJmMB0Ej2Quc4pgrAZVvqRxuaLCdOvVDHIXTisexkMPtNFBLQSdXYWd8PoLXG7Fm9XK3+AA/85f0oJIlUpl3A9LGBqWAf48jK+dxoNP1QI0e/NR2AbDwhRVsIv584E9IEMBGlphl0TEn1iYMxvoL0jVtvxS9+sQG9vWW0223k83m88upuWrFyBSul2FqXQZ7mdzQ96kvnTaRiCulZ14nvPyIgLsjomK0yR9mA9CIMokNSBQBYYGoJYDqD6R/ufCfOzkRyUztireWvLF+OIxOTkFIin4uwYsUKvLxrJwIV+kBpql1JQz6vAV3r0WUEZyROSgWh1OQpc0+q+3dG3jgS7Ovze+n5cv6VMMwZpUKJdGbqrEnmD/z8nJSLOFuUjkBk4FhrkcvlsfnZZ3joxiHM6u3Bunvuw/qHH+ZCsZypx4z8JC03mUSmBZA0D+zSvaRUwVEuj1yusOuccxYcmYnXmQCgarXKAOj0xYtfKBR7X4lyeRJCuGwDk0Rn8oTJbl47hQmfN6d3kLgMrwp53HvvvXzXXf8Ta9asYZVkeSmj2S9T/qiz7OSrU9k3SotU6LyfbNtzodiLcqnnKSKyAwMDM0rJTKjwsmWD6vLK+fvmnND3WO/sPggSTgjJ5BsVfMmp06gAXzDqNEKlVBERdxqlRNo3AJCv9Fzx5St57569UCrIKsm+D0KkCEwBYsqC+8cZPZTMI3zTFCsVyJ5Z79LzTpr3GAD09fXNELEdwwYsXjzuiIgXnLzwOyfOXWCCMJJKKkghKev58wUHTkFI+wApXQES3N0rSEmZmoRMEUI+n/ebL0DWQOkBFcn2uSTRPad/Rsk1deaUvjlTpH2IZGfNmStPPGn+L29a/Sf/F6jIarXqpjN/LAlAtVp1AwMD6pYb//MT8+YvXj+3/1RJgqxUCkLK9GQhJAnpiU07RH0JTZCQEtJvr5H0153Tj+PfE5KkDCCVouSElIpkZx4IoYiE9GN2dZqm93wBVKZdJhyEOepfcLo7bdHptxFRXKnMxKU/ZqqVMQCcf/75johw693rr52cGD9vcmJs4eGx/XEQkDLGMDsHl2xjHVUyAZI9Rc5sQreKZIFSYki4e+os8uwEX51mzKnWMdX/rFdQBRBCmIWnLo3mn/LutbcMDf5scHAwSDrJZ3SDx44j0GmUvOHmv7zg179+4kejzz5empwYix07mTVJJmls94hdzZD+UyQ7SyQgEqvZMagd0rI2OKQNVZyFtNm1N/BdIBCEkJBSMhGZ+YvOiN7z3rMf/eLnPnvx8PCftTZu3DglkXlTAACgwcFBtW7dOn3N1+/52JbfPPPAju3P9B3c97J2zoEBkQKQ8iG622K9LnPaPNWlx53rlDrn0rbYrMXO5wNdjdTOZQXRjHgfFNkwjOSCxWfK0979vp/+/kfP/U+PVD82tnTpEI+MjMyo+8cLAABQpVIJqtVqfNNffPd3t2zecvurLz9/wd7dO1CbGLeOrU1ckEjb2DpGUkDKIOsCkypkoRSUVERSshQSBEEMZms0+W5QnXSG+i5TnyZr+L5Cm+0iOedbqpQK5Ox3nSROmr+4feppS7798YvOvel7d901CQDVatW+IXPHAQAAYHBwMJg3b5298MLnin/9t3/3mVdf2fFfxg7uO3tycgzNxmSyMYoO00GAIMghyuWRyxcR5YvI5YsoFMvI5wuI8nlEUS7ZP3CI2200m3W0mg006jW0GjW0mjW0W03ouAWtY5i4DWsNiAgqUMgXyij3zmn3zT35kUWLT/9vN1/7+Q2VSiUEYI+H+TcFAAAaGBiSfX2jolqtxr/4xW9P2LDp6Q8c2L/nvGajcZaz5kSGyAdhKFQQchjmkCsUqVzuFb2zerlYLFGukEdvT0n0lAuUL4Q2FypIAWkYaLUN1WstO1FrYmKi7iYOH6Z6rYZ6vcaNep0b9UnouMVxu2XhXF1IerXU07Pp1PkLf7X8Sxc9BVDrkkuGguNpkX+rAGTvDw4OqvHxcVq/fqkBhglA/vk9k3mr24GJhYxyzAUqUN1OBEoKJbSQiLztk0IoYY0KggAaGkKIIEDgW2Wki+M2O5IyRhuIARjljLSBaTZbrFRolXGWy+32e08+uUZE7UqlIgHIpUuXujfznyJvFYDu39HAwJDo64PAUmApgLGxMQKAOXPmUE9PDwELUCrlKL8oIgCYi7mwvS1Z1gVpSpZnYRakFAQcQRwX3f79B1jKnAWAI0e2EwBbr9cZAHbuBICdGJszh9tbt2aGbXx83HUFOW+K+bcDwNG/TQpUwzN0Yk0/zjzzTNq6tcLDw0i27IcB/9sZGUjHTJ+n22B4CwxPP94OANPH6S7YdFeE0uB9CrE87b9Gpz+f/m7q8qbN98/ieKdA/v/yOFaZ6R07/h8LvzIHQmZEsQAAAABJRU5ErkJggg=="><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;650;700;800&family=IBM+Plex+Mono:wght@400;500&display=swap"><style>/*! tailwindcss v4.3.3 | MIT License | https://tailwindcss.com */
@layer properties;
@layer theme, base, components, utilities;
@layer theme {
  :root, :host {
    --font-sans: "Manrope", sans-serif;
    --font-mono: "IBM Plex Mono", monospace;
    --color-black: #000;
    --spacing: 0.25rem;
    --container-sm: 24rem;
    --container-md: 28rem;
    --container-lg: 32rem;
    --text-xs: 0.75rem;
    --text-xs--line-height: calc(1 / 0.75);
    --text-sm: 0.875rem;
    --text-sm--line-height: calc(1.25 / 0.875);
    --text-base: 1rem;
    --text-base--line-height: calc(1.5 / 1);
    --text-lg: 1.125rem;
    --text-lg--line-height: calc(1.75 / 1.125);
    --text-xl: 1.25rem;
    --text-xl--line-height: calc(1.75 / 1.25);
    --text-2xl: 1.5rem;
    --text-2xl--line-height: calc(2 / 1.5);
    --text-7xl: 4.5rem;
    --text-7xl--line-height: 1;
    --font-weight-normal: 400;
    --font-weight-medium: 500;
    --font-weight-semibold: 600;
    --font-weight-bold: 700;
    --tracking-tight: -0.025em;
    --tracking-wide: 0.025em;
    --tracking-wider: 0.05em;
    --tracking-widest: 0.1em;
    --leading-relaxed: 1.625;
    --ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
    --animate-pulse: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
    --blur-md: 12px;
    --aspect-video: 16 / 9;
    --default-transition-duration: 150ms;
    --default-transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
    --default-font-family: "Manrope", sans-serif;
    --default-mono-font-family: "IBM Plex Mono", monospace;
    --color-border: var(--border);
  }
}
@layer base {
  *, ::after, ::before, ::backdrop, ::file-selector-button {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    border: 0 solid;
  }
  html, :host {
    line-height: 1.5;
    -webkit-text-size-adjust: 100%;
    tab-size: 4;
    font-family: var(--default-font-family, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", "Noto Sans", Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji");
    font-feature-settings: var(--default-font-feature-settings, normal);
    font-variation-settings: var(--default-font-variation-settings, normal);
    -webkit-tap-highlight-color: transparent;
  }
  hr {
    height: 0;
    color: inherit;
    border-top-width: 1px;
  }
  abbr:where([title]) {
    -webkit-text-decoration: underline dotted;
    text-decoration: underline dotted;
  }
  h1, h2, h3, h4, h5, h6 {
    font-size: inherit;
    font-weight: inherit;
  }
  a {
    color: inherit;
    -webkit-text-decoration: inherit;
    text-decoration: inherit;
  }
  b, strong {
    font-weight: bolder;
  }
  code, kbd, samp, pre {
    font-family: var(--default-mono-font-family, ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace);
    font-feature-settings: var(--default-mono-font-feature-settings, normal);
    font-variation-settings: var(--default-mono-font-variation-settings, normal);
    font-size: 1em;
  }
  small {
    font-size: 80%;
  }
  sub, sup {
    font-size: 75%;
    line-height: 0;
    position: relative;
    vertical-align: baseline;
  }
  sub {
    bottom: -0.25em;
  }
  sup {
    top: -0.5em;
  }
  table {
    text-indent: 0;
    border-color: inherit;
    border-collapse: collapse;
  }
  :-moz-focusring:where(:not(iframe)) {
    outline: auto;
  }
  progress {
    vertical-align: baseline;
  }
  summary {
    display: list-item;
  }
  ol, ul, menu {
    list-style: none;
  }
  img, svg, video, canvas, audio, iframe, embed, object {
    display: block;
    vertical-align: middle;
  }
  img, video {
    max-width: 100%;
    height: auto;
  }
  button, input, select, optgroup, textarea, ::file-selector-button {
    font: inherit;
    font-feature-settings: inherit;
    font-variation-settings: inherit;
    letter-spacing: inherit;
    color: inherit;
    border-radius: 0;
    background-color: transparent;
    opacity: 1;
  }
  :where(select:is([multiple], [size])) optgroup {
    font-weight: bolder;
  }
  :where(select:is([multiple], [size])) optgroup option {
    padding-inline-start: 20px;
  }
  ::file-selector-button {
    margin-inline-end: 4px;
  }
  ::placeholder {
    opacity: 1;
  }
  @supports (not (-webkit-appearance: -apple-pay-button))  or (contain-intrinsic-size: 1px) {
    ::placeholder {
      color: currentcolor;
      @supports (color: color-mix(in lab, red, red)) {
        color: color-mix(in oklab, currentcolor 50%, transparent);
      }
    }
  }
  textarea {
    resize: vertical;
  }
  ::-webkit-search-decoration {
    -webkit-appearance: none;
  }
  ::-webkit-date-and-time-value {
    min-height: 1lh;
    text-align: inherit;
  }
  ::-webkit-datetime-edit {
    display: inline-flex;
  }
  ::-webkit-datetime-edit-fields-wrapper {
    padding: 0;
  }
  ::-webkit-datetime-edit, ::-webkit-datetime-edit-year-field, ::-webkit-datetime-edit-month-field, ::-webkit-datetime-edit-day-field, ::-webkit-datetime-edit-hour-field, ::-webkit-datetime-edit-minute-field, ::-webkit-datetime-edit-second-field, ::-webkit-datetime-edit-millisecond-field, ::-webkit-datetime-edit-meridiem-field {
    padding-block: 0;
  }
  ::-webkit-calendar-picker-indicator {
    line-height: 1;
  }
  :-moz-ui-invalid {
    box-shadow: none;
  }
  button, input:where([type="button"], [type="reset"], [type="submit"]), ::file-selector-button {
    appearance: button;
  }
  ::-webkit-inner-spin-button, ::-webkit-outer-spin-button {
    height: auto;
  }
  [hidden]:where(:not([hidden="until-found"])) {
    display: none !important;
  }
}
@layer utilities {
  .pointer-events-none {
    pointer-events: none;
  }
  .invisible {
    visibility: hidden;
  }
  .sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    margin: -1px;
    overflow: hidden;
    clip-path: inset(50%);
    white-space: nowrap;
    border-width: 0;
  }
  .absolute {
    position: absolute;
  }
  .fixed {
    position: fixed;
  }
  .relative {
    position: relative;
  }
  .inset-0 {
    inset: 0px;
  }
  .inset-x-0 {
    inset-inline: 0px;
  }
  .inset-y-0 {
    inset-block: 0px;
  }
  .-top-12 {
    top: calc(var(--spacing) * -12);
  }
  .top-0 {
    top: 0px;
  }
  .top-1\.5 {
    top: calc(var(--spacing) * 1.5);
  }
  .top-1\/2 {
    top: calc(1 / 2 * 100%);
  }
  .top-3\.5 {
    top: calc(var(--spacing) * 3.5);
  }
  .top-4 {
    top: calc(var(--spacing) * 4);
  }
  .top-\[1px\] {
    top: 1px;
  }
  .top-\[50\%\] {
    top: 50%;
  }
  .top-\[60\%\] {
    top: 60%;
  }
  .top-\[calc\(100\%\+10px\)\] {
    top: calc(100% + 10px);
  }
  .top-full {
    top: 100%;
  }
  .-right-12 {
    right: calc(var(--spacing) * -12);
  }
  .right-0 {
    right: 0px;
  }
  .right-1 {
    right: var(--spacing);
  }
  .right-2 {
    right: calc(var(--spacing) * 2);
  }
  .right-3 {
    right: calc(var(--spacing) * 3);
  }
  .right-4 {
    right: calc(var(--spacing) * 4);
  }
  .right-5 {
    right: calc(var(--spacing) * 5);
  }
  .-bottom-12 {
    bottom: calc(var(--spacing) * -12);
  }
  .bottom-0 {
    bottom: 0px;
  }
  .bottom-5 {
    bottom: calc(var(--spacing) * 5);
  }
  .-left-12 {
    left: calc(var(--spacing) * -12);
  }
  .left-0 {
    left: 0px;
  }
  .left-1\/2 {
    left: calc(1 / 2 * 100%);
  }
  .left-2 {
    left: calc(var(--spacing) * 2);
  }
  .left-\[50\%\] {
    left: 50%;
  }
  .z-10 {
    z-index: 10;
  }
  .z-20 {
    z-index: 20;
  }
  .z-50 {
    z-index: 50;
  }
  .z-\[1\] {
    z-index: 1;
  }
  .-mx-1 {
    margin-inline: calc(var(--spacing) * -1);
  }
  .mx-2 {
    margin-inline: calc(var(--spacing) * 2);
  }
  .mx-3\.5 {
    margin-inline: calc(var(--spacing) * 3.5);
  }
  .mx-auto {
    margin-inline: auto;
  }
  .my-0\.5 {
    margin-block: calc(var(--spacing) * 0.5);
  }
  .my-1 {
    margin-block: var(--spacing);
  }
  .-mt-4 {
    margin-top: calc(var(--spacing) * -4);
  }
  .mt-1 {
    margin-top: var(--spacing);
  }
  .mt-1\.5 {
    margin-top: calc(var(--spacing) * 1.5);
  }
  .mt-2 {
    margin-top: calc(var(--spacing) * 2);
  }
  .mt-4 {
    margin-top: calc(var(--spacing) * 4);
  }
  .mt-5 {
    margin-top: calc(var(--spacing) * 5);
  }
  .mt-6 {
    margin-top: calc(var(--spacing) * 6);
  }
  .mt-24 {
    margin-top: calc(var(--spacing) * 24);
  }
  .mt-auto {
    margin-top: auto;
  }
  .mr-1 {
    margin-right: var(--spacing);
  }
  .mr-2 {
    margin-right: calc(var(--spacing) * 2);
  }
  .mb-1 {
    margin-bottom: var(--spacing);
  }
  .-ml-4 {
    margin-left: calc(var(--spacing) * -4);
  }
  .ml-1 {
    margin-left: var(--spacing);
  }
  .ml-auto {
    margin-left: auto;
  }
  .block {
    display: block;
  }
  .flex {
    display: flex;
  }
  .grid {
    display: grid;
  }
  .hidden {
    display: none;
  }
  .inline-flex {
    display: inline-flex;
  }
  .table {
    display: table;
  }
  .aspect-square {
    aspect-ratio: 1 / 1;
  }
  .aspect-video {
    aspect-ratio: var(--aspect-video);
  }
  .size-\(--cell-size\) {
    width: var(--cell-size);
    height: var(--cell-size);
  }
  .size-4 {
    width: calc(var(--spacing) * 4);
    height: calc(var(--spacing) * 4);
  }
  .h-\(--cell-size\) {
    height: var(--cell-size);
  }
  .h-1\.5 {
    height: calc(var(--spacing) * 1.5);
  }
  .h-2 {
    height: calc(var(--spacing) * 2);
  }
  .h-2\.5 {
    height: calc(var(--spacing) * 2.5);
  }
  .h-3 {
    height: calc(var(--spacing) * 3);
  }
  .h-3\.5 {
    height: calc(var(--spacing) * 3.5);
  }
  .h-4 {
    height: calc(var(--spacing) * 4);
  }
  .h-5 {
    height: calc(var(--spacing) * 5);
  }
  .h-7 {
    height: calc(var(--spacing) * 7);
  }
  .h-8 {
    height: calc(var(--spacing) * 8);
  }
  .h-9 {
    height: calc(var(--spacing) * 9);
  }
  .h-10 {
    height: calc(var(--spacing) * 10);
  }
  .h-12 {
    height: calc(var(--spacing) * 12);
  }
  .h-\[1px\] {
    height: 1px;
  }
  .h-\[var\(--radix-navigation-menu-viewport-height\)\] {
    height: var(--radix-navigation-menu-viewport-height);
  }
  .h-\[var\(--radix-select-trigger-height\)\] {
    height: var(--radix-select-trigger-height);
  }
  .h-auto {
    height: auto;
  }
  .h-full {
    height: 100%;
  }
  .h-px {
    height: 1px;
  }
  .h-svh {
    height: 100svh;
  }
  .max-h-\(--radix-context-menu-content-available-height\) {
    max-height: var(--radix-context-menu-content-available-height);
  }
  .max-h-\(--radix-select-content-available-height\) {
    max-height: var(--radix-select-content-available-height);
  }
  .max-h-\[300px\] {
    max-height: 300px;
  }
  .max-h-\[var\(--radix-dropdown-menu-content-available-height\)\] {
    max-height: var(--radix-dropdown-menu-content-available-height);
  }
  .min-h-0 {
    min-height: 0px;
  }
  .min-h-\[60px\] {
    min-height: 60px;
  }
  .min-h-\[220px\] {
    min-height: 220px;
  }
  .min-h-screen {
    min-height: 100vh;
  }
  .min-h-svh {
    min-height: 100svh;
  }
  .w-\(--cell-size\) {
    width: var(--cell-size);
  }
  .w-\(--sidebar-width\) {
    width: var(--sidebar-width);
  }
  .w-0 {
    width: 0px;
  }
  .w-1 {
    width: var(--spacing);
  }
  .w-2 {
    width: calc(var(--spacing) * 2);
  }
  .w-2\.5 {
    width: calc(var(--spacing) * 2.5);
  }
  .w-3 {
    width: calc(var(--spacing) * 3);
  }
  .w-3\.5 {
    width: calc(var(--spacing) * 3.5);
  }
  .w-3\/4 {
    width: calc(3 / 4 * 100%);
  }
  .w-4 {
    width: calc(var(--spacing) * 4);
  }
  .w-5 {
    width: calc(var(--spacing) * 5);
  }
  .w-7 {
    width: calc(var(--spacing) * 7);
  }
  .w-8 {
    width: calc(var(--spacing) * 8);
  }
  .w-9 {
    width: calc(var(--spacing) * 9);
  }
  .w-10 {
    width: calc(var(--spacing) * 10);
  }
  .w-64 {
    width: calc(var(--spacing) * 64);
  }
  .w-72 {
    width: calc(var(--spacing) * 72);
  }
  .w-\[1px\] {
    width: 1px;
  }
  .w-\[100px\] {
    width: 100px;
  }
  .w-\[280px\] {
    width: 280px;
  }
  .w-auto {
    width: auto;
  }
  .w-fit {
    width: fit-content;
  }
  .w-full {
    width: 100%;
  }
  .w-max {
    width: max-content;
  }
  .w-px {
    width: 1px;
  }
  .max-w-\(--skeleton-width\) {
    max-width: var(--skeleton-width);
  }
  .max-w-\[420px\] {
    max-width: 420px;
  }
  .max-w-lg {
    max-width: var(--container-lg);
  }
  .max-w-max {
    max-width: max-content;
  }
  .max-w-md {
    max-width: var(--container-md);
  }
  .min-w-\(--cell-size\) {
    min-width: var(--cell-size);
  }
  .min-w-0 {
    min-width: 0px;
  }
  .min-w-5 {
    min-width: calc(var(--spacing) * 5);
  }
  .min-w-8 {
    min-width: calc(var(--spacing) * 8);
  }
  .min-w-9 {
    min-width: calc(var(--spacing) * 9);
  }
  .min-w-10 {
    min-width: calc(var(--spacing) * 10);
  }
  .min-w-\[8rem\] {
    min-width: 8rem;
  }
  .min-w-\[12rem\] {
    min-width: 12rem;
  }
  .min-w-\[var\(--radix-select-trigger-width\)\] {
    min-width: var(--radix-select-trigger-width);
  }
  .flex-1 {
    flex: 1;
  }
  .shrink-0 {
    flex-shrink: 0;
  }
  .grow {
    flex-grow: 1;
  }
  .grow-0 {
    flex-grow: 0;
  }
  .basis-full {
    flex-basis: 100%;
  }
  .caption-bottom {
    caption-side: bottom;
  }
  .border-collapse {
    border-collapse: collapse;
  }
  .origin-\(--radix-context-menu-content-transform-origin\) {
    transform-origin: var(--radix-context-menu-content-transform-origin);
  }
  .origin-\(--radix-dropdown-menu-content-transform-origin\) {
    transform-origin: var(--radix-dropdown-menu-content-transform-origin);
  }
  .origin-\(--radix-hover-card-content-transform-origin\) {
    transform-origin: var(--radix-hover-card-content-transform-origin);
  }
  .origin-\(--radix-menubar-content-transform-origin\) {
    transform-origin: var(--radix-menubar-content-transform-origin);
  }
  .origin-\(--radix-popover-content-transform-origin\) {
    transform-origin: var(--radix-popover-content-transform-origin);
  }
  .origin-\(--radix-select-content-transform-origin\) {
    transform-origin: var(--radix-select-content-transform-origin);
  }
  .origin-\(--radix-tooltip-content-transform-origin\) {
    transform-origin: var(--radix-tooltip-content-transform-origin);
  }
  .-translate-x-1\/2 {
    --tw-translate-x: calc(calc(1 / 2 * 100%) * -1);
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }
  .-translate-x-px {
    --tw-translate-x: -1px;
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }
  .translate-x-\[-50\%\] {
    --tw-translate-x: -50%;
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }
  .translate-x-px {
    --tw-translate-x: 1px;
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }
  .-translate-y-1\/2 {
    --tw-translate-y: calc(calc(1 / 2 * 100%) * -1);
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }
  .translate-y-\[-50\%\] {
    --tw-translate-y: -50%;
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }
  .rotate-45 {
    rotate: 45deg;
  }
  .rotate-90 {
    rotate: 90deg;
  }
  .transform {
    transform: var(--tw-rotate-x,) var(--tw-rotate-y,) var(--tw-rotate-z,) var(--tw-skew-x,) var(--tw-skew-y,);
  }
  .animate-caret-blink {
    animation: caret-blink 1.25s ease-out infinite;
  }
  .animate-in {
    animation: enter var(--tw-animation-duration,var(--tw-duration,.15s))var(--tw-ease,ease)var(--tw-animation-delay,0s)var(--tw-animation-iteration-count,1)var(--tw-animation-direction,normal)var(--tw-animation-fill-mode,none);
  }
  .animate-pulse {
    animation: var(--animate-pulse);
  }
  .cursor-default {
    cursor: default;
  }
  .cursor-pointer {
    cursor: pointer;
  }
  .touch-none {
    touch-action: none;
  }
  .list-none {
    list-style-type: none;
  }
  .grid-cols-4 {
    grid-template-columns: repeat(4, minmax(0, 1fr));
  }
  .grid-cols-5 {
    grid-template-columns: repeat(5, minmax(0, 1fr));
  }
  .grid-cols-\[1fr_auto\] {
    grid-template-columns: 1fr auto;
  }
  .flex-col {
    flex-direction: column;
  }
  .flex-col-reverse {
    flex-direction: column-reverse;
  }
  .flex-row {
    flex-direction: row;
  }
  .flex-wrap {
    flex-wrap: wrap;
  }
  .place-content-center {
    place-content: center;
  }
  .place-items-center {
    place-items: center;
  }
  .items-center {
    align-items: center;
  }
  .items-end {
    align-items: flex-end;
  }
  .items-start {
    align-items: flex-start;
  }
  .items-stretch {
    align-items: stretch;
  }
  .justify-between {
    justify-content: space-between;
  }
  .justify-center {
    justify-content: center;
  }
  .gap-1 {
    gap: var(--spacing);
  }
  .gap-1\.5 {
    gap: calc(var(--spacing) * 1.5);
  }
  .gap-2 {
    gap: calc(var(--spacing) * 2);
  }
  .gap-2\.5 {
    gap: calc(var(--spacing) * 2.5);
  }
  .gap-3 {
    gap: calc(var(--spacing) * 3);
  }
  .gap-4 {
    gap: calc(var(--spacing) * 4);
  }
  :where(.space-y-1\.5 > :not(:last-child)) {
    --tw-space-y-reverse: 0;
    margin-block-start: calc(calc(var(--spacing) * 1.5) * var(--tw-space-y-reverse));
    margin-block-end: calc(calc(var(--spacing) * 1.5) * calc(1 - var(--tw-space-y-reverse)));
  }
  :where(.space-y-2 > :not(:last-child)) {
    --tw-space-y-reverse: 0;
    margin-block-start: calc(calc(var(--spacing) * 2) * var(--tw-space-y-reverse));
    margin-block-end: calc(calc(var(--spacing) * 2) * calc(1 - var(--tw-space-y-reverse)));
  }
  :where(.space-x-1 > :not(:last-child)) {
    --tw-space-x-reverse: 0;
    margin-inline-start: calc(var(--spacing) * var(--tw-space-x-reverse));
    margin-inline-end: calc(var(--spacing) * calc(1 - var(--tw-space-x-reverse)));
  }
  .self-center {
    align-self: center;
  }
  .overflow-auto {
    overflow: auto;
  }
  .overflow-hidden {
    overflow: hidden;
  }
  .overflow-x-auto {
    overflow-x: auto;
  }
  .overflow-x-hidden {
    overflow-x: hidden;
  }
  .overflow-y-auto {
    overflow-y: auto;
  }
  .rounded-2xl {
    border-radius: 8px;
  }
  .rounded-\[2px\] {
    border-radius: 2px;
  }
  .rounded-\[inherit\] {
    border-radius: inherit;
  }
  .rounded-full {
    border-radius: calc(infinity * 1px);
  }
  .rounded-lg {
    border-radius: 8px;
  }
  .rounded-md {
    border-radius: 6px;
  }
  .rounded-none {
    border-radius: 0;
  }
  .rounded-sm {
    border-radius: 4px;
  }
  .rounded-xl {
    border-radius: 8px;
  }
  .rounded-t-\[10px\] {
    border-top-left-radius: 10px;
    border-top-right-radius: 10px;
  }
  .rounded-l-md {
    border-top-left-radius: 6px;
    border-bottom-left-radius: 6px;
  }
  .rounded-tl-sm {
    border-top-left-radius: 4px;
  }
  .rounded-r-md {
    border-top-right-radius: 6px;
    border-bottom-right-radius: 6px;
  }
  .border {
    border-style: var(--tw-border-style);
    border-width: 1px;
  }
  .border-2 {
    border-style: var(--tw-border-style);
    border-width: 2px;
  }
  .border-\[1\.5px\] {
    border-style: var(--tw-border-style);
    border-width: 1.5px;
  }
  .border-y {
    border-block-style: var(--tw-border-style);
    border-block-width: 1px;
  }
  .border-t {
    border-top-style: var(--tw-border-style);
    border-top-width: 1px;
  }
  .border-r {
    border-right-style: var(--tw-border-style);
    border-right-width: 1px;
  }
  .border-b {
    border-bottom-style: var(--tw-border-style);
    border-bottom-width: 1px;
  }
  .border-l {
    border-left-style: var(--tw-border-style);
    border-left-width: 1px;
  }
  .border-dashed {
    --tw-border-style: dashed;
    border-style: dashed;
  }
  .border-\(--color-border\) {
    border-color: var(--color-border);
  }
  .border-border {
    border-color: var(--border);
  }
  .border-border\/50 {
    border-color: var(--border);
    @supports (color: color-mix(in lab, red, red)) {
      border-color: color-mix(in oklab, var(--border) 50%, transparent);
    }
  }
  .border-destructive\/40 {
    border-color: var(--destructive);
    @supports (color: color-mix(in lab, red, red)) {
      border-color: color-mix(in oklab, var(--destructive) 40%, transparent);
    }
  }
  .border-destructive\/50 {
    border-color: var(--destructive);
    @supports (color: color-mix(in lab, red, red)) {
      border-color: color-mix(in oklab, var(--destructive) 50%, transparent);
    }
  }
  .border-input {
    border-color: var(--border);
  }
  .border-primary {
    border-color: var(--primary);
  }
  .border-primary\/50 {
    border-color: var(--primary);
    @supports (color: color-mix(in lab, red, red)) {
      border-color: color-mix(in oklab, var(--primary) 50%, transparent);
    }
  }
  .border-success\/40 {
    border-color: var(--success);
    @supports (color: color-mix(in lab, red, red)) {
      border-color: color-mix(in oklab, var(--success) 40%, transparent);
    }
  }
  .border-transparent {
    border-color: transparent;
  }
  .border-t-transparent {
    border-top-color: transparent;
  }
  .border-l-transparent {
    border-left-color: transparent;
  }
  .bg-\(--color-bg\) {
    background-color: var(--color-bg);
  }
  .bg-accent {
    background-color: var(--accent);
  }
  .bg-background {
    background-color: var(--background);
  }
  .bg-black\/80 {
    background-color: color-mix(in srgb, #000 80%, transparent);
    @supports (color: color-mix(in lab, red, red)) {
      background-color: color-mix(in oklab, var(--color-black) 80%, transparent);
    }
  }
  .bg-border {
    background-color: var(--border);
  }
  .bg-card {
    background-color: var(--card);
  }
  .bg-destructive {
    background-color: var(--destructive);
  }
  .bg-foreground {
    background-color: var(--foreground);
  }
  .bg-muted {
    background-color: var(--secondary);
  }
  .bg-muted\/50 {
    background-color: var(--secondary);
    @supports (color: color-mix(in lab, red, red)) {
      background-color: color-mix(in oklab, var(--secondary) 50%, transparent);
    }
  }
  .bg-popover {
    background-color: var(--popover);
  }
  .bg-primary {
    background-color: var(--primary);
  }
  .bg-primary\/10 {
    background-color: var(--primary);
    @supports (color: color-mix(in lab, red, red)) {
      background-color: color-mix(in oklab, var(--primary) 10%, transparent);
    }
  }
  .bg-primary\/20 {
    background-color: var(--primary);
    @supports (color: color-mix(in lab, red, red)) {
      background-color: color-mix(in oklab, var(--primary) 20%, transparent);
    }
  }
  .bg-secondary {
    background-color: var(--secondary);
  }
  .bg-transparent {
    background-color: transparent;
  }
  .fill-current {
    fill: currentcolor;
  }
  .fill-primary {
    fill: var(--primary);
  }
  .object-cover {
    object-fit: cover;
  }
  .p-0 {
    padding: 0px;
  }
  .p-1 {
    padding: var(--spacing);
  }
  .p-2 {
    padding: calc(var(--spacing) * 2);
  }
  .p-3 {
    padding: calc(var(--spacing) * 3);
  }
  .p-4 {
    padding: calc(var(--spacing) * 4);
  }
  .p-5 {
    padding: calc(var(--spacing) * 5);
  }
  .p-6 {
    padding: calc(var(--spacing) * 6);
  }
  .p-7 {
    padding: calc(var(--spacing) * 7);
  }
  .p-\[1px\] {
    padding: 1px;
  }
  .px-\(--cell-size\) {
    padding-inline: var(--cell-size);
  }
  .px-1 {
    padding-inline: var(--spacing);
  }
  .px-1\.5 {
    padding-inline: calc(var(--spacing) * 1.5);
  }
  .px-2 {
    padding-inline: calc(var(--spacing) * 2);
  }
  .px-2\.5 {
    padding-inline: calc(var(--spacing) * 2.5);
  }
  .px-3 {
    padding-inline: calc(var(--spacing) * 3);
  }
  .px-4 {
    padding-inline: calc(var(--spacing) * 4);
  }
  .px-8 {
    padding-inline: calc(var(--spacing) * 8);
  }
  .py-0 {
    padding-block: 0px;
  }
  .py-0\.5 {
    padding-block: calc(var(--spacing) * 0.5);
  }
  .py-1 {
    padding-block: var(--spacing);
  }
  .py-1\.5 {
    padding-block: calc(var(--spacing) * 1.5);
  }
  .py-2 {
    padding-block: calc(var(--spacing) * 2);
  }
  .py-2\.5 {
    padding-block: calc(var(--spacing) * 2.5);
  }
  .py-3 {
    padding-block: calc(var(--spacing) * 3);
  }
  .py-4 {
    padding-block: calc(var(--spacing) * 4);
  }
  .py-6 {
    padding-block: calc(var(--spacing) * 6);
  }
  .pt-0 {
    padding-top: 0px;
  }
  .pt-3 {
    padding-top: calc(var(--spacing) * 3);
  }
  .pt-4 {
    padding-top: calc(var(--spacing) * 4);
  }
  .pr-1 {
    padding-right: var(--spacing);
  }
  .pr-2 {
    padding-right: calc(var(--spacing) * 2);
  }
  .pr-2\.5 {
    padding-right: calc(var(--spacing) * 2.5);
  }
  .pr-8 {
    padding-right: calc(var(--spacing) * 8);
  }
  .pb-3 {
    padding-bottom: calc(var(--spacing) * 3);
  }
  .pb-4 {
    padding-bottom: calc(var(--spacing) * 4);
  }
  .pl-2 {
    padding-left: calc(var(--spacing) * 2);
  }
  .pl-2\.5 {
    padding-left: calc(var(--spacing) * 2.5);
  }
  .pl-3 {
    padding-left: calc(var(--spacing) * 3);
  }
  .pl-4 {
    padding-left: calc(var(--spacing) * 4);
  }
  .pl-8 {
    padding-left: calc(var(--spacing) * 8);
  }
  .text-center {
    text-align: center;
  }
  .text-left {
    text-align: left;
  }
  .text-right {
    text-align: right;
  }
  .align-middle {
    vertical-align: middle;
  }
  .font-mono {
    font-family: "IBM Plex Mono", monospace;
  }
  .text-2xl {
    font-size: var(--text-2xl);
    line-height: var(--tw-leading, var(--text-2xl--line-height));
  }
  .text-7xl {
    font-size: var(--text-7xl);
    line-height: var(--tw-leading, var(--text-7xl--line-height));
  }
  .text-base {
    font-size: var(--text-base);
    line-height: var(--tw-leading, var(--text-base--line-height));
  }
  .text-lg {
    font-size: var(--text-lg);
    line-height: var(--tw-leading, var(--text-lg--line-height));
  }
  .text-sm {
    font-size: var(--text-sm);
    line-height: var(--tw-leading, var(--text-sm--line-height));
  }
  .text-xl {
    font-size: var(--text-xl);
    line-height: var(--tw-leading, var(--text-xl--line-height));
  }
  .text-xs {
    font-size: var(--text-xs);
    line-height: var(--tw-leading, var(--text-xs--line-height));
  }
  .text-\[0\.8rem\] {
    font-size: 0.8rem;
  }
  .text-\[10px\] {
    font-size: 10px;
  }
  .text-\[11px\] {
    font-size: 11px;
  }
  .text-\[12px\] {
    font-size: 12px;
  }
  .text-\[13px\] {
    font-size: 13px;
  }
  .leading-none {
    --tw-leading: 1;
    line-height: 1;
  }
  .leading-relaxed {
    --tw-leading: var(--leading-relaxed);
    line-height: var(--leading-relaxed);
  }
  .font-bold {
    --tw-font-weight: var(--font-weight-bold);
    font-weight: var(--font-weight-bold);
  }
  .font-medium {
    --tw-font-weight: var(--font-weight-medium);
    font-weight: var(--font-weight-medium);
  }
  .font-normal {
    --tw-font-weight: var(--font-weight-normal);
    font-weight: var(--font-weight-normal);
  }
  .font-semibold {
    --tw-font-weight: var(--font-weight-semibold);
    font-weight: var(--font-weight-semibold);
  }
  .tracking-\[\.12em\] {
    --tw-tracking: .12em;
    letter-spacing: .12em;
  }
  .tracking-\[\.14em\] {
    --tw-tracking: .14em;
    letter-spacing: .14em;
  }
  .tracking-tight {
    --tw-tracking: var(--tracking-tight);
    letter-spacing: var(--tracking-tight);
  }
  .tracking-wide {
    --tw-tracking: var(--tracking-wide);
    letter-spacing: var(--tracking-wide);
  }
  .tracking-wider {
    --tw-tracking: var(--tracking-wider);
    letter-spacing: var(--tracking-wider);
  }
  .tracking-widest {
    --tw-tracking: var(--tracking-widest);
    letter-spacing: var(--tracking-widest);
  }
  .break-words {
    overflow-wrap: break-word;
  }
  .whitespace-nowrap {
    white-space: nowrap;
  }
  .text-accent-foreground {
    color: var(--foreground);
  }
  .text-card-foreground {
    color: var(--foreground);
  }
  .text-current {
    color: currentcolor;
  }
  .text-destructive {
    color: var(--destructive);
  }
  .text-foreground {
    color: var(--foreground);
  }
  .text-muted-foreground {
    color: var(--muted-foreground);
  }
  .text-popover-foreground {
    color: var(--foreground);
  }
  .text-primary {
    color: var(--primary);
  }
  .text-primary-foreground {
    color: var(--primary-foreground);
  }
  .text-secondary-foreground {
    color: var(--foreground);
  }
  .text-success {
    color: var(--success);
  }
  .uppercase {
    text-transform: uppercase;
  }
  .tabular-nums {
    --tw-numeric-spacing: tabular-nums;
    font-variant-numeric: var(--tw-ordinal,) var(--tw-slashed-zero,) var(--tw-numeric-figure,) var(--tw-numeric-spacing,) var(--tw-numeric-fraction,);
  }
  .underline-offset-2 {
    text-underline-offset: 2px;
  }
  .underline-offset-4 {
    text-underline-offset: 4px;
  }
  .opacity-0 {
    opacity: 0%;
  }
  .opacity-50 {
    opacity: 50%;
  }
  .opacity-60 {
    opacity: 60%;
  }
  .opacity-70 {
    opacity: 70%;
  }
  .shadow {
    --tw-shadow: 0 1px 3px 0 var(--tw-shadow-color, rgb(0 0 0 / 0.1)), 0 1px 2px -1px var(--tw-shadow-color, rgb(0 0 0 / 0.1));
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .shadow-2xl {
    --tw-shadow: 0 25px 50px -12px var(--tw-shadow-color, rgb(0 0 0 / 0.25));
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .shadow-\[0_0_0_1px_var\(--sidebar-border\)\] {
    --tw-shadow: 0 0 0 1px var(--tw-shadow-color, var(--sidebar-border));
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .shadow-lg {
    --tw-shadow: 0 10px 15px -3px var(--tw-shadow-color, rgb(0 0 0 / 0.1)), 0 4px 6px -4px var(--tw-shadow-color, rgb(0 0 0 / 0.1));
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .shadow-md {
    --tw-shadow: 0 4px 6px -1px var(--tw-shadow-color, rgb(0 0 0 / 0.1)), 0 2px 4px -2px var(--tw-shadow-color, rgb(0 0 0 / 0.1));
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .shadow-none {
    --tw-shadow: 0 0 #0000;
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .shadow-sm {
    --tw-shadow: 0 1px 3px 0 var(--tw-shadow-color, rgb(0 0 0 / 0.1)), 0 1px 2px -1px var(--tw-shadow-color, rgb(0 0 0 / 0.1));
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .shadow-xl {
    --tw-shadow: 0 20px 25px -5px var(--tw-shadow-color, rgb(0 0 0 / 0.1)), 0 8px 10px -6px var(--tw-shadow-color, rgb(0 0 0 / 0.1));
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .shadow-xs {
    --tw-shadow: 0 1px 2px 0 var(--tw-shadow-color, rgb(0 0 0 / 0.05));
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .ring-0 {
    --tw-ring-shadow: var(--tw-ring-inset,) 0 0 0 calc(0px + var(--tw-ring-offset-width)) var(--tw-ring-color, currentcolor);
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .ring-1 {
    --tw-ring-shadow: var(--tw-ring-inset,) 0 0 0 calc(1px + var(--tw-ring-offset-width)) var(--tw-ring-color, currentcolor);
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .ring-ring {
    --tw-ring-color: var(--ring);
  }
  .ring-offset-background {
    --tw-ring-offset-color: var(--background);
  }
  .outline {
    outline-style: var(--tw-outline-style);
    outline-width: 1px;
  }
  .filter {
    filter: var(--tw-blur,) var(--tw-brightness,) var(--tw-contrast,) var(--tw-grayscale,) var(--tw-hue-rotate,) var(--tw-invert,) var(--tw-saturate,) var(--tw-sepia,) var(--tw-drop-shadow,);
  }
  .backdrop-blur-md {
    --tw-backdrop-blur: blur(var(--blur-md));
    -webkit-backdrop-filter: var(--tw-backdrop-blur,) var(--tw-backdrop-brightness,) var(--tw-backdrop-contrast,) var(--tw-backdrop-grayscale,) var(--tw-backdrop-hue-rotate,) var(--tw-backdrop-invert,) var(--tw-backdrop-opacity,) var(--tw-backdrop-saturate,) var(--tw-backdrop-sepia,);
    backdrop-filter: var(--tw-backdrop-blur,) var(--tw-backdrop-brightness,) var(--tw-backdrop-contrast,) var(--tw-backdrop-grayscale,) var(--tw-backdrop-hue-rotate,) var(--tw-backdrop-invert,) var(--tw-backdrop-opacity,) var(--tw-backdrop-saturate,) var(--tw-backdrop-sepia,);
  }
  .transition {
    transition-property: color, background-color, border-color, outline-color, text-decoration-color, fill, stroke, --tw-gradient-from, --tw-gradient-via, --tw-gradient-to, opacity, box-shadow, transform, translate, scale, rotate, filter, -webkit-backdrop-filter, backdrop-filter, display, content-visibility, overlay, pointer-events;
    transition-timing-function: var(--tw-ease, var(--default-transition-timing-function));
    transition-duration: var(--tw-duration, var(--default-transition-duration));
  }
  .transition-\[left\,right\,width\] {
    transition-property: left,right,width;
    transition-timing-function: var(--tw-ease, var(--default-transition-timing-function));
    transition-duration: var(--tw-duration, var(--default-transition-duration));
  }
  .transition-\[margin\,opacity\] {
    transition-property: margin,opacity;
    transition-timing-function: var(--tw-ease, var(--default-transition-timing-function));
    transition-duration: var(--tw-duration, var(--default-transition-duration));
  }
  .transition-\[width\,height\,padding\] {
    transition-property: width,height,padding;
    transition-timing-function: var(--tw-ease, var(--default-transition-timing-function));
    transition-duration: var(--tw-duration, var(--default-transition-duration));
  }
  .transition-\[width\] {
    transition-property: width;
    transition-timing-function: var(--tw-ease, var(--default-transition-timing-function));
    transition-duration: var(--tw-duration, var(--default-transition-duration));
  }
  .transition-all {
    transition-property: all;
    transition-timing-function: var(--tw-ease, var(--default-transition-timing-function));
    transition-duration: var(--tw-duration, var(--default-transition-duration));
  }
  .transition-colors {
    transition-property: color, background-color, border-color, outline-color, text-decoration-color, fill, stroke, --tw-gradient-from, --tw-gradient-via, --tw-gradient-to;
    transition-timing-function: var(--tw-ease, var(--default-transition-timing-function));
    transition-duration: var(--tw-duration, var(--default-transition-duration));
  }
  .transition-opacity {
    transition-property: opacity;
    transition-timing-function: var(--tw-ease, var(--default-transition-timing-function));
    transition-duration: var(--tw-duration, var(--default-transition-duration));
  }
  .transition-transform {
    transition-property: transform, translate, scale, rotate;
    transition-timing-function: var(--tw-ease, var(--default-transition-timing-function));
    transition-duration: var(--tw-duration, var(--default-transition-duration));
  }
  .duration-200 {
    --tw-duration: 200ms;
    transition-duration: 200ms;
  }
  .duration-300 {
    --tw-duration: 300ms;
    transition-duration: 300ms;
  }
  .duration-1000 {
    --tw-duration: 1000ms;
    transition-duration: 1000ms;
  }
  .ease-in-out {
    --tw-ease: var(--ease-in-out);
    transition-timing-function: var(--ease-in-out);
  }
  .ease-linear {
    --tw-ease: linear;
    transition-timing-function: linear;
  }
  .fade-in-0 {
    --tw-enter-opacity: calc(0/100);
    --tw-enter-opacity: 0;
  }
  .outline-none {
    --tw-outline-style: none;
    outline-style: none;
  }
  .select-none {
    -webkit-user-select: none;
    user-select: none;
  }
  .zoom-in-95 {
    --tw-enter-scale: calc(95*1%);
    --tw-enter-scale: .95;
  }
  .\[--cell-size\:2rem\] {
    --cell-size: 2rem;
  }
  .running {
    animation-play-state: running;
  }
  .group-focus-within\/menu-item\:opacity-100:is(:where(.group\/menu-item):focus-within *) {
    opacity: 100%;
  }
  @media (hover: hover) {
    .group-hover\/menu-item\:opacity-100:is(:where(.group\/menu-item):hover *) {
      opacity: 100%;
    }
  }
  .group-has-\[\[data-sidebar\=menu-action\]\]\/menu-item\:pr-8:is(:where(.group\/menu-item):has(:is([data-sidebar=menu-action])) *) {
    padding-right: calc(var(--spacing) * 8);
  }
  .group-data-\[collapsible\=icon\]\:-mt-8:is(:where(.group)[data-collapsible="icon"] *) {
    margin-top: calc(var(--spacing) * -8);
  }
  .group-data-\[collapsible\=icon\]\:hidden:is(:where(.group)[data-collapsible="icon"] *) {
    display: none;
  }
  .group-data-\[collapsible\=icon\]\:\!size-8:is(:where(.group)[data-collapsible="icon"] *) {
    width: calc(var(--spacing) * 8) !important;
    height: calc(var(--spacing) * 8) !important;
  }
  .group-data-\[collapsible\=icon\]\:w-\(--sidebar-width-icon\):is(:where(.group)[data-collapsible="icon"] *) {
    width: var(--sidebar-width-icon);
  }
  .group-data-\[collapsible\=icon\]\:w-\[calc\(var\(--sidebar-width-icon\)_\+_theme\(spacing\.4\)\)\]:is(:where(.group)[data-collapsible="icon"] *) {
    width: calc(var(--sidebar-width-icon) + 1rem);
  }
  .group-data-\[collapsible\=icon\]\:w-\[calc\(var\(--sidebar-width-icon\)_\+_theme\(spacing\.4\)_\+2px\)\]:is(:where(.group)[data-collapsible="icon"] *) {
    width: calc(var(--sidebar-width-icon) + 1rem + 2px);
  }
  .group-data-\[collapsible\=icon\]\:overflow-hidden:is(:where(.group)[data-collapsible="icon"] *) {
    overflow: hidden;
  }
  .group-data-\[collapsible\=icon\]\:\!p-0:is(:where(.group)[data-collapsible="icon"] *) {
    padding: 0px !important;
  }
  .group-data-\[collapsible\=icon\]\:\!p-2:is(:where(.group)[data-collapsible="icon"] *) {
    padding: calc(var(--spacing) * 2) !important;
  }
  .group-data-\[collapsible\=icon\]\:opacity-0:is(:where(.group)[data-collapsible="icon"] *) {
    opacity: 0%;
  }
  .group-data-\[collapsible\=offcanvas\]\:right-\[calc\(var\(--sidebar-width\)\*-1\)\]:is(:where(.group)[data-collapsible="offcanvas"] *) {
    right: calc(var(--sidebar-width) * -1);
  }
  .group-data-\[collapsible\=offcanvas\]\:left-\[calc\(var\(--sidebar-width\)\*-1\)\]:is(:where(.group)[data-collapsible="offcanvas"] *) {
    left: calc(var(--sidebar-width) * -1);
  }
  .group-data-\[collapsible\=offcanvas\]\:w-0:is(:where(.group)[data-collapsible="offcanvas"] *) {
    width: 0px;
  }
  .group-data-\[collapsible\=offcanvas\]\:translate-x-0:is(:where(.group)[data-collapsible="offcanvas"] *) {
    --tw-translate-x: 0px;
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }
  .group-data-\[focused\=true\]\/day\:relative:is(:where(.group\/day)[data-focused="true"] *) {
    position: relative;
  }
  .group-data-\[focused\=true\]\/day\:z-10:is(:where(.group\/day)[data-focused="true"] *) {
    z-index: 10;
  }
  .group-data-\[focused\=true\]\/day\:border-ring:is(:where(.group\/day)[data-focused="true"] *) {
    border-color: var(--ring);
  }
  .group-data-\[focused\=true\]\/day\:ring-\[3px\]:is(:where(.group\/day)[data-focused="true"] *) {
    --tw-ring-shadow: var(--tw-ring-inset,) 0 0 0 calc(3px + var(--tw-ring-offset-width)) var(--tw-ring-color, currentcolor);
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .group-data-\[focused\=true\]\/day\:ring-ring\/50:is(:where(.group\/day)[data-focused="true"] *) {
    --tw-ring-color: var(--ring);
    @supports (color: color-mix(in lab, red, red)) {
      --tw-ring-color: color-mix(in oklab, var(--ring) 50%, transparent);
    }
  }
  .group-data-\[side\=left\]\:-right-4:is(:where(.group)[data-side="left"] *) {
    right: calc(var(--spacing) * -4);
  }
  .group-data-\[side\=left\]\:border-r:is(:where(.group)[data-side="left"] *) {
    border-right-style: var(--tw-border-style);
    border-right-width: 1px;
  }
  .group-data-\[side\=right\]\:left-0:is(:where(.group)[data-side="right"] *) {
    left: 0px;
  }
  .group-data-\[side\=right\]\:rotate-180:is(:where(.group)[data-side="right"] *) {
    rotate: 180deg;
  }
  .group-data-\[side\=right\]\:border-l:is(:where(.group)[data-side="right"] *) {
    border-left-style: var(--tw-border-style);
    border-left-width: 1px;
  }
  .group-data-\[state\=open\]\:rotate-180:is(:where(.group)[data-state="open"] *) {
    rotate: 180deg;
  }
  .group-data-\[variant\=floating\]\:rounded-lg:is(:where(.group)[data-variant="floating"] *) {
    border-radius: 8px;
  }
  .group-data-\[variant\=floating\]\:border:is(:where(.group)[data-variant="floating"] *) {
    border-style: var(--tw-border-style);
    border-width: 1px;
  }
  .group-data-\[variant\=floating\]\:shadow:is(:where(.group)[data-variant="floating"] *) {
    --tw-shadow: 0 1px 3px 0 var(--tw-shadow-color, rgb(0 0 0 / 0.1)), 0 1px 2px -1px var(--tw-shadow-color, rgb(0 0 0 / 0.1));
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .group-\[\.toast\]\:bg-muted:is(:where(.group):is(.toast) *) {
    background-color: var(--secondary);
  }
  .group-\[\.toast\]\:bg-primary:is(:where(.group):is(.toast) *) {
    background-color: var(--primary);
  }
  .group-\[\.toast\]\:text-muted-foreground:is(:where(.group):is(.toast) *) {
    color: var(--muted-foreground);
  }
  .group-\[\.toast\]\:text-primary-foreground:is(:where(.group):is(.toast) *) {
    color: var(--primary-foreground);
  }
  .group-\[\.toaster\]\:border-border:is(:where(.group):is(.toaster) *) {
    border-color: var(--border);
  }
  .group-\[\.toaster\]\:bg-background:is(:where(.group):is(.toaster) *) {
    background-color: var(--background);
  }
  .group-\[\.toaster\]\:text-foreground:is(:where(.group):is(.toaster) *) {
    color: var(--foreground);
  }
  .group-\[\.toaster\]\:shadow-lg:is(:where(.group):is(.toaster) *) {
    --tw-shadow: 0 10px 15px -3px var(--tw-shadow-color, rgb(0 0 0 / 0.1)), 0 4px 6px -4px var(--tw-shadow-color, rgb(0 0 0 / 0.1));
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .peer-disabled\:cursor-not-allowed:is(:where(.peer):disabled ~ *) {
    cursor: not-allowed;
  }
  .peer-disabled\:opacity-70:is(:where(.peer):disabled ~ *) {
    opacity: 70%;
  }
  .peer-data-\[size\=default\]\/menu-button\:top-1\.5:is(:where(.peer\/menu-button)[data-size="default"] ~ *) {
    top: calc(var(--spacing) * 1.5);
  }
  .peer-data-\[size\=lg\]\/menu-button\:top-2\.5:is(:where(.peer\/menu-button)[data-size="lg"] ~ *) {
    top: calc(var(--spacing) * 2.5);
  }
  .peer-data-\[size\=sm\]\/menu-button\:top-1:is(:where(.peer\/menu-button)[data-size="sm"] ~ *) {
    top: var(--spacing);
  }
  .file\:border-0::file-selector-button {
    border-style: var(--tw-border-style);
    border-width: 0px;
  }
  .file\:bg-transparent::file-selector-button {
    background-color: transparent;
  }
  .file\:text-sm::file-selector-button {
    font-size: var(--text-sm);
    line-height: var(--tw-leading, var(--text-sm--line-height));
  }
  .file\:font-medium::file-selector-button {
    --tw-font-weight: var(--font-weight-medium);
    font-weight: var(--font-weight-medium);
  }
  .file\:text-foreground::file-selector-button {
    color: var(--foreground);
  }
  .placeholder\:text-muted-foreground::placeholder {
    color: var(--muted-foreground);
  }
  .after\:absolute::after {
    content: var(--tw-content);
    position: absolute;
  }
  .after\:-inset-2::after {
    content: var(--tw-content);
    inset: calc(var(--spacing) * -2);
  }
  .after\:inset-y-0::after {
    content: var(--tw-content);
    inset-block: 0px;
  }
  .after\:left-1\/2::after {
    content: var(--tw-content);
    left: calc(1 / 2 * 100%);
  }
  .after\:w-1::after {
    content: var(--tw-content);
    width: var(--spacing);
  }
  .after\:w-\[2px\]::after {
    content: var(--tw-content);
    width: 2px;
  }
  .after\:-translate-x-1\/2::after {
    content: var(--tw-content);
    --tw-translate-x: calc(calc(1 / 2 * 100%) * -1);
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }
  .group-data-\[collapsible\=offcanvas\]\:after\:left-full:is(:where(.group)[data-collapsible="offcanvas"] *)::after {
    content: var(--tw-content);
    left: 100%;
  }
  .first\:rounded-l-md:first-child {
    border-top-left-radius: 6px;
    border-bottom-left-radius: 6px;
  }
  .first\:border-l:first-child {
    border-left-style: var(--tw-border-style);
    border-left-width: 1px;
  }
  .last\:rounded-r-md:last-child {
    border-top-right-radius: 6px;
    border-bottom-right-radius: 6px;
  }
  @media (hover: hover) {
    .hover\:bg-accent:hover {
      background-color: var(--accent);
    }
    .hover\:bg-destructive\/80:hover {
      background-color: var(--destructive);
    }
    @supports (color: color-mix(in lab, red, red)) {
      .hover\:bg-destructive\/80:hover {
        background-color: color-mix(in oklab, var(--destructive) 80%, transparent);
      }
    }
    .hover\:bg-destructive\/90:hover {
      background-color: var(--destructive);
    }
    @supports (color: color-mix(in lab, red, red)) {
      .hover\:bg-destructive\/90:hover {
        background-color: color-mix(in oklab, var(--destructive) 90%, transparent);
      }
    }
    .hover\:bg-muted:hover {
      background-color: var(--secondary);
    }
    .hover\:bg-muted\/50:hover {
      background-color: var(--secondary);
    }
    @supports (color: color-mix(in lab, red, red)) {
      .hover\:bg-muted\/50:hover {
        background-color: color-mix(in oklab, var(--secondary) 50%, transparent);
      }
    }
    .hover\:bg-primary\/80:hover {
      background-color: var(--primary);
    }
    @supports (color: color-mix(in lab, red, red)) {
      .hover\:bg-primary\/80:hover {
        background-color: color-mix(in oklab, var(--primary) 80%, transparent);
      }
    }
    .hover\:bg-primary\/90:hover {
      background-color: var(--primary);
    }
    @supports (color: color-mix(in lab, red, red)) {
      .hover\:bg-primary\/90:hover {
        background-color: color-mix(in oklab, var(--primary) 90%, transparent);
      }
    }
    .hover\:bg-secondary:hover {
      background-color: var(--secondary);
    }
    .hover\:bg-secondary\/80:hover {
      background-color: var(--secondary);
    }
    @supports (color: color-mix(in lab, red, red)) {
      .hover\:bg-secondary\/80:hover {
        background-color: color-mix(in oklab, var(--secondary) 80%, transparent);
      }
    }
    .hover\:text-accent-foreground:hover {
      color: var(--foreground);
    }
    .hover\:text-foreground:hover {
      color: var(--foreground);
    }
    .hover\:text-muted-foreground:hover {
      color: var(--muted-foreground);
    }
    .hover\:underline:hover {
      text-decoration-line: underline;
    }
    .hover\:opacity-100:hover {
      opacity: 100%;
    }
    .hover\:shadow-\[0_0_0_1px_var\(--sidebar-accent\)\]:hover {
      --tw-shadow: 0 0 0 1px var(--tw-shadow-color, var(--sidebar-accent));
      box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
    }
  }
  .focus\:border-border:focus {
    border-color: var(--border);
  }
  .focus\:bg-accent:focus {
    background-color: var(--accent);
  }
  .focus\:text-accent-foreground:focus {
    color: var(--foreground);
  }
  .focus\:ring-1:focus {
    --tw-ring-shadow: var(--tw-ring-inset,) 0 0 0 calc(1px + var(--tw-ring-offset-width)) var(--tw-ring-color, currentcolor);
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .focus\:ring-2:focus {
    --tw-ring-shadow: var(--tw-ring-inset,) 0 0 0 calc(2px + var(--tw-ring-offset-width)) var(--tw-ring-color, currentcolor);
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .focus\:ring-ring:focus {
    --tw-ring-color: var(--ring);
  }
  .focus\:ring-offset-2:focus {
    --tw-ring-offset-width: 2px;
    --tw-ring-offset-shadow: var(--tw-ring-inset,) 0 0 0 var(--tw-ring-offset-width) var(--tw-ring-offset-color);
  }
  .focus\:outline-none:focus {
    --tw-outline-style: none;
    outline-style: none;
  }
  .focus-visible\:ring-1:focus-visible {
    --tw-ring-shadow: var(--tw-ring-inset,) 0 0 0 calc(1px + var(--tw-ring-offset-width)) var(--tw-ring-color, currentcolor);
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .focus-visible\:ring-2:focus-visible {
    --tw-ring-shadow: var(--tw-ring-inset,) 0 0 0 calc(2px + var(--tw-ring-offset-width)) var(--tw-ring-color, currentcolor);
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .focus-visible\:ring-ring:focus-visible {
    --tw-ring-color: var(--ring);
  }
  .focus-visible\:ring-offset-1:focus-visible {
    --tw-ring-offset-width: 1px;
    --tw-ring-offset-shadow: var(--tw-ring-inset,) 0 0 0 var(--tw-ring-offset-width) var(--tw-ring-offset-color);
  }
  .focus-visible\:ring-offset-2:focus-visible {
    --tw-ring-offset-width: 2px;
    --tw-ring-offset-shadow: var(--tw-ring-inset,) 0 0 0 var(--tw-ring-offset-width) var(--tw-ring-offset-color);
  }
  .focus-visible\:ring-offset-background:focus-visible {
    --tw-ring-offset-color: var(--background);
  }
  .focus-visible\:outline-none:focus-visible {
    --tw-outline-style: none;
    outline-style: none;
  }
  .disabled\:pointer-events-none:disabled {
    pointer-events: none;
  }
  .disabled\:cursor-not-allowed:disabled {
    cursor: not-allowed;
  }
  .disabled\:opacity-50:disabled {
    opacity: 50%;
  }
  .has-focus\:border-ring:has(:focus) {
    border-color: var(--ring);
  }
  .has-focus\:ring-\[3px\]:has(:focus) {
    --tw-ring-shadow: var(--tw-ring-inset,) 0 0 0 calc(3px + var(--tw-ring-offset-width)) var(--tw-ring-color, currentcolor);
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .has-focus\:ring-ring\/50:has(:focus) {
    --tw-ring-color: var(--ring);
    @supports (color: color-mix(in lab, red, red)) {
      --tw-ring-color: color-mix(in oklab, var(--ring) 50%, transparent);
    }
  }
  .has-\[\:disabled\]\:opacity-50:has(:is(:disabled)) {
    opacity: 50%;
  }
  .aria-disabled\:pointer-events-none[aria-disabled="true"] {
    pointer-events: none;
  }
  .aria-disabled\:opacity-50[aria-disabled="true"] {
    opacity: 50%;
  }
  .aria-selected\:text-muted-foreground[aria-selected="true"] {
    color: var(--muted-foreground);
  }
  .data-\[active\=true\]\:font-medium[data-active="true"] {
    --tw-font-weight: var(--font-weight-medium);
    font-weight: var(--font-weight-medium);
  }
  .data-\[disabled\]\:pointer-events-none[data-disabled] {
    pointer-events: none;
  }
  .data-\[disabled\]\:opacity-50[data-disabled] {
    opacity: 50%;
  }
  .data-\[disabled\=true\]\:pointer-events-none[data-disabled="true"] {
    pointer-events: none;
  }
  .data-\[disabled\=true\]\:opacity-50[data-disabled="true"] {
    opacity: 50%;
  }
  .data-\[motion\=from-end\]\:slide-in-from-right-52[data-motion="from-end"] {
    --tw-enter-translate-x: calc(52*var(--spacing));
  }
  .data-\[motion\=from-start\]\:slide-in-from-left-52[data-motion="from-start"] {
    --tw-enter-translate-x: calc(52*var(--spacing)*-1);
  }
  .data-\[motion\=to-end\]\:slide-out-to-right-52[data-motion="to-end"] {
    --tw-exit-translate-x: calc(52*var(--spacing));
  }
  .data-\[motion\=to-start\]\:slide-out-to-left-52[data-motion="to-start"] {
    --tw-exit-translate-x: calc(52*var(--spacing)*-1);
  }
  .data-\[motion\^\=from-\]\:animate-in[data-motion^="from-"] {
    animation: enter var(--tw-animation-duration,var(--tw-duration,.15s))var(--tw-ease,ease)var(--tw-animation-delay,0s)var(--tw-animation-iteration-count,1)var(--tw-animation-direction,normal)var(--tw-animation-fill-mode,none);
  }
  .data-\[motion\^\=from-\]\:fade-in[data-motion^="from-"] {
    --tw-enter-opacity: 0;
  }
  .data-\[motion\^\=to-\]\:animate-out[data-motion^="to-"] {
    animation: exit var(--tw-animation-duration,var(--tw-duration,.15s))var(--tw-ease,ease)var(--tw-animation-delay,0s)var(--tw-animation-iteration-count,1)var(--tw-animation-direction,normal)var(--tw-animation-fill-mode,none);
  }
  .data-\[motion\^\=to-\]\:fade-out[data-motion^="to-"] {
    --tw-exit-opacity: 0;
  }
  .data-\[panel-group-direction\=vertical\]\:h-px[data-panel-group-direction="vertical"] {
    height: 1px;
  }
  .data-\[panel-group-direction\=vertical\]\:w-full[data-panel-group-direction="vertical"] {
    width: 100%;
  }
  .data-\[panel-group-direction\=vertical\]\:flex-col[data-panel-group-direction="vertical"] {
    flex-direction: column;
  }
  .data-\[panel-group-direction\=vertical\]\:after\:left-0[data-panel-group-direction="vertical"]::after {
    content: var(--tw-content);
    left: 0px;
  }
  .data-\[panel-group-direction\=vertical\]\:after\:h-1[data-panel-group-direction="vertical"]::after {
    content: var(--tw-content);
    height: var(--spacing);
  }
  .data-\[panel-group-direction\=vertical\]\:after\:w-full[data-panel-group-direction="vertical"]::after {
    content: var(--tw-content);
    width: 100%;
  }
  .data-\[panel-group-direction\=vertical\]\:after\:translate-x-0[data-panel-group-direction="vertical"]::after {
    content: var(--tw-content);
    --tw-translate-x: 0px;
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }
  .data-\[panel-group-direction\=vertical\]\:after\:-translate-y-1\/2[data-panel-group-direction="vertical"]::after {
    content: var(--tw-content);
    --tw-translate-y: calc(calc(1 / 2 * 100%) * -1);
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }
  .data-\[placeholder\]\:text-muted-foreground[data-placeholder] {
    color: var(--muted-foreground);
  }
  .data-\[range-end\=true\]\:rounded-md[data-range-end="true"] {
    border-radius: 6px;
  }
  .data-\[range-end\=true\]\:bg-primary[data-range-end="true"] {
    background-color: var(--primary);
  }
  .data-\[range-end\=true\]\:text-primary-foreground[data-range-end="true"] {
    color: var(--primary-foreground);
  }
  .data-\[range-middle\=true\]\:rounded-none[data-range-middle="true"] {
    border-radius: 0;
  }
  .data-\[range-middle\=true\]\:bg-accent[data-range-middle="true"] {
    background-color: var(--accent);
  }
  .data-\[range-middle\=true\]\:text-accent-foreground[data-range-middle="true"] {
    color: var(--foreground);
  }
  .data-\[range-start\=true\]\:rounded-md[data-range-start="true"] {
    border-radius: 6px;
  }
  .data-\[range-start\=true\]\:bg-primary[data-range-start="true"] {
    background-color: var(--primary);
  }
  .data-\[range-start\=true\]\:text-primary-foreground[data-range-start="true"] {
    color: var(--primary-foreground);
  }
  .data-\[selected-single\=true\]\:bg-primary[data-selected-single="true"] {
    background-color: var(--primary);
  }
  .data-\[selected-single\=true\]\:text-primary-foreground[data-selected-single="true"] {
    color: var(--primary-foreground);
  }
  .data-\[selected\=true\]\:rounded-none[data-selected="true"] {
    border-radius: 0;
  }
  .data-\[selected\=true\]\:bg-accent[data-selected="true"] {
    background-color: var(--accent);
  }
  .data-\[selected\=true\]\:text-accent-foreground[data-selected="true"] {
    color: var(--foreground);
  }
  .data-\[side\=bottom\]\:translate-y-1[data-side="bottom"] {
    --tw-translate-y: var(--spacing);
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }
  .data-\[side\=bottom\]\:slide-in-from-top-2[data-side="bottom"] {
    --tw-enter-translate-y: calc(2*var(--spacing)*-1);
  }
  .data-\[side\=left\]\:-translate-x-1[data-side="left"] {
    --tw-translate-x: calc(var(--spacing) * -1);
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }
  .data-\[side\=left\]\:slide-in-from-right-2[data-side="left"] {
    --tw-enter-translate-x: calc(2*var(--spacing));
  }
  .data-\[side\=right\]\:translate-x-1[data-side="right"] {
    --tw-translate-x: var(--spacing);
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }
  .data-\[side\=right\]\:slide-in-from-left-2[data-side="right"] {
    --tw-enter-translate-x: calc(2*var(--spacing)*-1);
  }
  .data-\[side\=top\]\:-translate-y-1[data-side="top"] {
    --tw-translate-y: calc(var(--spacing) * -1);
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }
  .data-\[side\=top\]\:slide-in-from-bottom-2[data-side="top"] {
    --tw-enter-translate-y: calc(2*var(--spacing));
  }
  .data-\[state\=active\]\:bg-background[data-state="active"] {
    background-color: var(--background);
  }
  .data-\[state\=active\]\:text-foreground[data-state="active"] {
    color: var(--foreground);
  }
  .data-\[state\=active\]\:shadow[data-state="active"] {
    --tw-shadow: 0 1px 3px 0 var(--tw-shadow-color, rgb(0 0 0 / 0.1)), 0 1px 2px -1px var(--tw-shadow-color, rgb(0 0 0 / 0.1));
    box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
  }
  .data-\[state\=checked\]\:translate-x-4[data-state="checked"] {
    --tw-translate-x: calc(var(--spacing) * 4);
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }
  .data-\[state\=checked\]\:bg-primary[data-state="checked"] {
    background-color: var(--primary);
  }
  .data-\[state\=checked\]\:text-primary-foreground[data-state="checked"] {
    color: var(--primary-foreground);
  }
  .data-\[state\=closed\]\:animate-accordion-up[data-state="closed"] {
    animation: accordion-up var(--tw-animation-duration,var(--tw-duration,.2s))var(--tw-ease,ease-out)var(--tw-animation-delay,0s)var(--tw-animation-iteration-count,1)var(--tw-animation-direction,normal)var(--tw-animation-fill-mode,none);
  }
  .data-\[state\=closed\]\:animate-out[data-state="closed"] {
    animation: exit var(--tw-animation-duration,var(--tw-duration,.15s))var(--tw-ease,ease)var(--tw-animation-delay,0s)var(--tw-animation-iteration-count,1)var(--tw-animation-direction,normal)var(--tw-animation-fill-mode,none);
  }
  .data-\[state\=closed\]\:duration-300[data-state="closed"] {
    --tw-duration: 300ms;
    transition-duration: 300ms;
  }
  .data-\[state\=closed\]\:fade-out-0[data-state="closed"] {
    --tw-exit-opacity: calc(0/100);
    --tw-exit-opacity: 0;
  }
  .data-\[state\=closed\]\:zoom-out-95[data-state="closed"] {
    --tw-exit-scale: calc(95*1%);
    --tw-exit-scale: .95;
  }
  .data-\[state\=closed\]\:slide-out-to-bottom[data-state="closed"] {
    --tw-exit-translate-y: 100%;
  }
  .data-\[state\=closed\]\:slide-out-to-left[data-state="closed"] {
    --tw-exit-translate-x: -100%;
  }
  .data-\[state\=closed\]\:slide-out-to-right[data-state="closed"] {
    --tw-exit-translate-x: 100%;
  }
  .data-\[state\=closed\]\:slide-out-to-top[data-state="closed"] {
    --tw-exit-translate-y: -100%;
  }
  .data-\[state\=hidden\]\:animate-out[data-state="hidden"] {
    animation: exit var(--tw-animation-duration,var(--tw-duration,.15s))var(--tw-ease,ease)var(--tw-animation-delay,0s)var(--tw-animation-iteration-count,1)var(--tw-animation-direction,normal)var(--tw-animation-fill-mode,none);
  }
  .data-\[state\=hidden\]\:fade-out[data-state="hidden"] {
    --tw-exit-opacity: 0;
  }
  .data-\[state\=on\]\:bg-accent[data-state="on"] {
    background-color: var(--accent);
  }
  .data-\[state\=on\]\:text-accent-foreground[data-state="on"] {
    color: var(--foreground);
  }
  .data-\[state\=open\]\:animate-accordion-down[data-state="open"] {
    animation: accordion-down var(--tw-animation-duration,var(--tw-duration,.2s))var(--tw-ease,ease-out)var(--tw-animation-delay,0s)var(--tw-animation-iteration-count,1)var(--tw-animation-direction,normal)var(--tw-animation-fill-mode,none);
  }
  .data-\[state\=open\]\:animate-in[data-state="open"] {
    animation: enter var(--tw-animation-duration,var(--tw-duration,.15s))var(--tw-ease,ease)var(--tw-animation-delay,0s)var(--tw-animation-iteration-count,1)var(--tw-animation-direction,normal)var(--tw-animation-fill-mode,none);
  }
  .data-\[state\=open\]\:bg-accent[data-state="open"] {
    background-color: var(--accent);
  }
  .data-\[state\=open\]\:bg-accent\/50[data-state="open"] {
    background-color: var(--accent);
    @supports (color: color-mix(in lab, red, red)) {
      background-color: color-mix(in oklab, var(--accent) 50%, transparent);
    }
  }
  .data-\[state\=open\]\:bg-secondary[data-state="open"] {
    background-color: var(--secondary);
  }
  .data-\[state\=open\]\:text-accent-foreground[data-state="open"] {
    color: var(--foreground);
  }
  .data-\[state\=open\]\:text-muted-foreground[data-state="open"] {
    color: var(--muted-foreground);
  }
  .data-\[state\=open\]\:opacity-100[data-state="open"] {
    opacity: 100%;
  }
  .data-\[state\=open\]\:duration-500[data-state="open"] {
    --tw-duration: 500ms;
    transition-duration: 500ms;
  }
  .data-\[state\=open\]\:fade-in-0[data-state="open"] {
    --tw-enter-opacity: calc(0/100);
    --tw-enter-opacity: 0;
  }
  .data-\[state\=open\]\:zoom-in-90[data-state="open"] {
    --tw-enter-scale: calc(90*1%);
    --tw-enter-scale: .9;
  }
  .data-\[state\=open\]\:zoom-in-95[data-state="open"] {
    --tw-enter-scale: calc(95*1%);
    --tw-enter-scale: .95;
  }
  .data-\[state\=open\]\:slide-in-from-bottom[data-state="open"] {
    --tw-enter-translate-y: 100%;
  }
  .data-\[state\=open\]\:slide-in-from-left[data-state="open"] {
    --tw-enter-translate-x: -100%;
  }
  .data-\[state\=open\]\:slide-in-from-right[data-state="open"] {
    --tw-enter-translate-x: 100%;
  }
  .data-\[state\=open\]\:slide-in-from-top[data-state="open"] {
    --tw-enter-translate-y: -100%;
  }
  @media (hover: hover) {
    .data-\[state\=open\]\:hover\:bg-accent[data-state="open"]:hover {
      background-color: var(--accent);
    }
  }
  .data-\[state\=open\]\:focus\:bg-accent[data-state="open"]:focus {
    background-color: var(--accent);
  }
  .data-\[state\=selected\]\:bg-muted[data-state="selected"] {
    background-color: var(--secondary);
  }
  .data-\[state\=unchecked\]\:translate-x-0[data-state="unchecked"] {
    --tw-translate-x: 0px;
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }
  .data-\[state\=unchecked\]\:bg-input[data-state="unchecked"] {
    background-color: var(--border);
  }
  .data-\[state\=visible\]\:animate-in[data-state="visible"] {
    animation: enter var(--tw-animation-duration,var(--tw-duration,.15s))var(--tw-ease,ease)var(--tw-animation-delay,0s)var(--tw-animation-iteration-count,1)var(--tw-animation-direction,normal)var(--tw-animation-fill-mode,none);
  }
  .data-\[state\=visible\]\:fade-in[data-state="visible"] {
    --tw-enter-opacity: 0;
  }
  @media (width < 48rem) {
    .max-md\:grid-cols-1 {
      grid-template-columns: repeat(1, minmax(0, 1fr));
    }
    .max-md\:grid-cols-2 {
      grid-template-columns: repeat(2, minmax(0, 1fr));
    }
  }
  @media (width >= 40rem) {
    .sm\:mt-0 {
      margin-top: 0px;
    }
    .sm\:flex {
      display: flex;
    }
    .sm\:max-w-sm {
      max-width: var(--container-sm);
    }
    .sm\:flex-row {
      flex-direction: row;
    }
    .sm\:justify-end {
      justify-content: flex-end;
    }
    .sm\:gap-2\.5 {
      gap: calc(var(--spacing) * 2.5);
    }
    :where(.sm\:space-x-2 > :not(:last-child)) {
      --tw-space-x-reverse: 0;
      margin-inline-start: calc(calc(var(--spacing) * 2) * var(--tw-space-x-reverse));
      margin-inline-end: calc(calc(var(--spacing) * 2) * calc(1 - var(--tw-space-x-reverse)));
    }
    .sm\:rounded-lg {
      border-radius: 8px;
    }
    .sm\:text-left {
      text-align: left;
    }
  }
  @media (width >= 48rem) {
    .md\:absolute {
      position: absolute;
    }
    .md\:block {
      display: block;
    }
    .md\:flex {
      display: flex;
    }
    .md\:w-\[var\(--radix-navigation-menu-viewport-width\)\] {
      width: var(--radix-navigation-menu-viewport-width);
    }
    .md\:w-auto {
      width: auto;
    }
    .md\:flex-row {
      flex-direction: row;
    }
    .md\:text-sm {
      font-size: var(--text-sm);
      line-height: var(--tw-leading, var(--text-sm--line-height));
    }
    .md\:opacity-0 {
      opacity: 0%;
    }
    .md\:peer-data-\[variant\=inset\]\:m-2:is(:where(.peer)[data-variant="inset"] ~ *) {
      margin: calc(var(--spacing) * 2);
    }
    .md\:peer-data-\[variant\=inset\]\:ml-0:is(:where(.peer)[data-variant="inset"] ~ *) {
      margin-left: 0px;
    }
    .md\:peer-data-\[variant\=inset\]\:rounded-xl:is(:where(.peer)[data-variant="inset"] ~ *) {
      border-radius: 8px;
    }
    .md\:peer-data-\[variant\=inset\]\:shadow:is(:where(.peer)[data-variant="inset"] ~ *) {
      --tw-shadow: 0 1px 3px 0 var(--tw-shadow-color, rgb(0 0 0 / 0.1)), 0 1px 2px -1px var(--tw-shadow-color, rgb(0 0 0 / 0.1));
      box-shadow: var(--tw-inset-shadow), var(--tw-inset-ring-shadow), var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow);
    }
    .md\:peer-data-\[state\=collapsed\]\:peer-data-\[variant\=inset\]\:ml-2:is(:where(.peer)[data-state="collapsed"] ~ *):is(:where(.peer)[data-variant="inset"] ~ *) {
      margin-left: calc(var(--spacing) * 2);
    }
  }
  .after\:md\:hidden::after {
    content: var(--tw-content);
    @media (width >= 48rem) {
      display: none;
    }
  }
  .dark\:border-destructive:is(.dark *) {
    border-color: var(--destructive);
  }
  .\[\&_\.recharts-cartesian-axis-tick_text\]\:fill-muted-foreground .recharts-cartesian-axis-tick text {
    fill: var(--muted-foreground);
  }
  .\[\&_\.recharts-cartesian-grid_line\[stroke\=\'\#ccc\'\]\]\:stroke-border\/50 .recharts-cartesian-grid line[stroke='#ccc'] {
    stroke: var(--border);
    @supports (color: color-mix(in lab, red, red)) {
      stroke: color-mix(in oklab, var(--border) 50%, transparent);
    }
  }
  .\[\&_\.recharts-curve\.recharts-tooltip-cursor\]\:stroke-border .recharts-curve.recharts-tooltip-cursor {
    stroke: var(--border);
  }
  .\[\&_\.recharts-dot\[stroke\=\'\#fff\'\]\]\:stroke-transparent .recharts-dot[stroke='#fff'] {
    stroke: transparent;
  }
  .\[\&_\.recharts-layer\]\:outline-none .recharts-layer {
    --tw-outline-style: none;
    outline-style: none;
  }
  .\[\&_\.recharts-polar-grid_\[stroke\=\'\#ccc\'\]\]\:stroke-border .recharts-polar-grid [stroke='#ccc'] {
    stroke: var(--border);
  }
  .\[\&_\.recharts-radial-bar-background-sector\]\:fill-muted .recharts-radial-bar-background-sector {
    fill: var(--secondary);
  }
  .\[\&_\.recharts-rectangle\.recharts-tooltip-cursor\]\:fill-muted .recharts-rectangle.recharts-tooltip-cursor {
    fill: var(--secondary);
  }
  .\[\&_\.recharts-reference-line_\[stroke\=\'\#ccc\'\]\]\:stroke-border .recharts-reference-line [stroke='#ccc'] {
    stroke: var(--border);
  }
  .\[\&_\.recharts-sector\]\:outline-none .recharts-sector {
    --tw-outline-style: none;
    outline-style: none;
  }
  .\[\&_\.recharts-sector\[stroke\=\'\#fff\'\]\]\:stroke-transparent .recharts-sector[stroke='#fff'] {
    stroke: transparent;
  }
  .\[\&_\.recharts-surface\]\:outline-none .recharts-surface {
    --tw-outline-style: none;
    outline-style: none;
  }
  .\[\&_\[cmdk-group-heading\]\]\:px-2 [cmdk-group-heading] {
    padding-inline: calc(var(--spacing) * 2);
  }
  .\[\&_\[cmdk-group-heading\]\]\:py-1\.5 [cmdk-group-heading] {
    padding-block: calc(var(--spacing) * 1.5);
  }
  .\[\&_\[cmdk-group-heading\]\]\:text-xs [cmdk-group-heading] {
    font-size: var(--text-xs);
    line-height: var(--tw-leading, var(--text-xs--line-height));
  }
  .\[\&_\[cmdk-group-heading\]\]\:font-medium [cmdk-group-heading] {
    --tw-font-weight: var(--font-weight-medium);
    font-weight: var(--font-weight-medium);
  }
  .\[\&_\[cmdk-group-heading\]\]\:text-muted-foreground [cmdk-group-heading] {
    color: var(--muted-foreground);
  }
  .\[\&_\[cmdk-group\]\]\:px-2 [cmdk-group] {
    padding-inline: calc(var(--spacing) * 2);
  }
  .\[\&_\[cmdk-group\]\:not\(\[hidden\]\)_\~\[cmdk-group\]\]\:pt-0 [cmdk-group]:not([hidden]) ~ [cmdk-group] {
    padding-top: 0px;
  }
  .\[\&_\[cmdk-input-wrapper\]_svg\]\:h-5 [cmdk-input-wrapper] svg {
    height: calc(var(--spacing) * 5);
  }
  .\[\&_\[cmdk-input-wrapper\]_svg\]\:w-5 [cmdk-input-wrapper] svg {
    width: calc(var(--spacing) * 5);
  }
  .\[\&_\[cmdk-input\]\]\:h-12 [cmdk-input] {
    height: calc(var(--spacing) * 12);
  }
  .\[\&_\[cmdk-item\]\]\:px-2 [cmdk-item] {
    padding-inline: calc(var(--spacing) * 2);
  }
  .\[\&_\[cmdk-item\]\]\:py-3 [cmdk-item] {
    padding-block: calc(var(--spacing) * 3);
  }
  .\[\&_\[cmdk-item\]_svg\]\:h-5 [cmdk-item] svg {
    height: calc(var(--spacing) * 5);
  }
  .\[\&_\[cmdk-item\]_svg\]\:w-5 [cmdk-item] svg {
    width: calc(var(--spacing) * 5);
  }
  .\[\&_p\]\:leading-relaxed p {
    --tw-leading: var(--leading-relaxed);
    line-height: var(--leading-relaxed);
  }
  .\[\&_svg\]\:pointer-events-none svg {
    pointer-events: none;
  }
  .\[\&_svg\]\:size-4 svg {
    width: calc(var(--spacing) * 4);
    height: calc(var(--spacing) * 4);
  }
  .\[\&_svg\]\:shrink-0 svg {
    flex-shrink: 0;
  }
  .\[\&_tr\]\:border-b tr {
    border-bottom-style: var(--tw-border-style);
    border-bottom-width: 1px;
  }
  .\[\&_tr\:last-child\]\:border-0 tr:last-child {
    border-style: var(--tw-border-style);
    border-width: 0px;
  }
  .\[\&\:first-child\[data-selected\=true\]_button\]\:rounded-l-md:first-child[data-selected=true] button {
    border-top-left-radius: 6px;
    border-bottom-left-radius: 6px;
  }
  .\[\&\:has\(\[role\=checkbox\]\)\]\:pr-0:has([role=checkbox]) {
    padding-right: 0px;
  }
  :is(.rtl\:\*\*\:\[\.rdp-button\\_next\>svg\]\:rotate-180:where(:dir(rtl), [dir="rtl"], [dir="rtl"] *) *):is(.rdp-button_next > svg) {
    rotate: 180deg;
  }
  :is(.rtl\:\*\*\:\[\.rdp-button\\_previous\>svg\]\:rotate-180:where(:dir(rtl), [dir="rtl"], [dir="rtl"] *) *):is(.rdp-button_previous > svg) {
    rotate: 180deg;
  }
  .\[\&\:last-child\[data-selected\=true\]_button\]\:rounded-r-md:last-child[data-selected=true] button {
    border-top-right-radius: 6px;
    border-bottom-right-radius: 6px;
  }
  .\[\&\>\[role\=checkbox\]\]\:translate-y-\[2px\] > [role=checkbox] {
    --tw-translate-y: 2px;
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }
  .\[\&\>button\]\:hidden > button {
    display: none;
  }
  .\[\&\>span\]\:line-clamp-1 > span {
    overflow: hidden;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 1;
  }
  .\[\&\>span\]\:text-xs > span {
    font-size: var(--text-xs);
    line-height: var(--tw-leading, var(--text-xs--line-height));
  }
  .\[\&\>span\]\:opacity-70 > span {
    opacity: 70%;
  }
  .\[\&\>span\:last-child\]\:truncate > span:last-child {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
  .\[\&\>svg\]\:absolute > svg {
    position: absolute;
  }
  .\[\&\>svg\]\:top-4 > svg {
    top: calc(var(--spacing) * 4);
  }
  .\[\&\>svg\]\:left-4 > svg {
    left: calc(var(--spacing) * 4);
  }
  .\[\&\>svg\]\:size-3\.5 > svg {
    width: calc(var(--spacing) * 3.5);
    height: calc(var(--spacing) * 3.5);
  }
  .\[\&\>svg\]\:size-4 > svg {
    width: calc(var(--spacing) * 4);
    height: calc(var(--spacing) * 4);
  }
  .\[\&\>svg\]\:h-2\.5 > svg {
    height: calc(var(--spacing) * 2.5);
  }
  .\[\&\>svg\]\:h-3 > svg {
    height: calc(var(--spacing) * 3);
  }
  .\[\&\>svg\]\:h-3\.5 > svg {
    height: calc(var(--spacing) * 3.5);
  }
  .\[\&\>svg\]\:w-2\.5 > svg {
    width: calc(var(--spacing) * 2.5);
  }
  .\[\&\>svg\]\:w-3 > svg {
    width: calc(var(--spacing) * 3);
  }
  .\[\&\>svg\]\:w-3\.5 > svg {
    width: calc(var(--spacing) * 3.5);
  }
  .\[\&\>svg\]\:shrink-0 > svg {
    flex-shrink: 0;
  }
  .\[\&\>svg\]\:text-destructive > svg {
    color: var(--destructive);
  }
  .\[\&\>svg\]\:text-foreground > svg {
    color: var(--foreground);
  }
  .\[\&\>svg\]\:text-muted-foreground > svg {
    color: var(--muted-foreground);
  }
  .\[\&\>svg\+div\]\:translate-y-\[-3px\] > svg + div {
    --tw-translate-y: -3px;
    translate: var(--tw-translate-x) var(--tw-translate-y);
  }
  .\[\&\>svg\~\*\]\:pl-7 > svg ~ * {
    padding-left: calc(var(--spacing) * 7);
  }
  .\[\&\>tr\]\:last\:border-b-0 > tr:last-child {
    border-bottom-style: var(--tw-border-style);
    border-bottom-width: 0px;
  }
  .\[\&\[data-panel-group-direction\=vertical\]\>div\]\:rotate-90[data-panel-group-direction=vertical] > div {
    rotate: 90deg;
  }
  .\[\&\[data-state\=open\]\>svg\]\:rotate-180[data-state=open] > svg {
    rotate: 180deg;
  }
  [data-side=left] .\[\[data-side\=left\]_\&\]\:cursor-w-resize {
    cursor: w-resize;
  }
  [data-side=left][data-collapsible=offcanvas] .\[\[data-side\=left\]\[data-collapsible\=offcanvas\]_\&\]\:-right-2 {
    right: calc(var(--spacing) * -2);
  }
  [data-side=left][data-state=collapsed] .\[\[data-side\=left\]\[data-state\=collapsed\]_\&\]\:cursor-e-resize {
    cursor: e-resize;
  }
  [data-side=right] .\[\[data-side\=right\]_\&\]\:cursor-e-resize {
    cursor: e-resize;
  }
  [data-side=right][data-collapsible=offcanvas] .\[\[data-side\=right\]\[data-collapsible\=offcanvas\]_\&\]\:-left-2 {
    left: calc(var(--spacing) * -2);
  }
  [data-side=right][data-state=collapsed] .\[\[data-side\=right\]\[data-state\=collapsed\]_\&\]\:cursor-w-resize {
    cursor: w-resize;
  }
  [data-slot=card-content] .\[\[data-slot\=card-content\]_\&\]\:bg-transparent {
    background-color: transparent;
  }
  [data-slot=popover-content] .\[\[data-slot\=popover-content\]_\&\]\:bg-transparent {
    background-color: transparent;
  }
}
@property --tw-animation-delay {
  syntax: "*";
  inherits: false;
  initial-value: 0s;
}
@property --tw-animation-direction {
  syntax: "*";
  inherits: false;
  initial-value: normal;
}
@property --tw-animation-duration {
  syntax: "*";
  inherits: false;
}
@property --tw-animation-fill-mode {
  syntax: "*";
  inherits: false;
  initial-value: none;
}
@property --tw-animation-iteration-count {
  syntax: "*";
  inherits: false;
  initial-value: 1;
}
@property --tw-enter-blur {
  syntax: "*";
  inherits: false;
  initial-value: 0;
}
@property --tw-enter-opacity {
  syntax: "*";
  inherits: false;
  initial-value: 1;
}
@property --tw-enter-rotate {
  syntax: "*";
  inherits: false;
  initial-value: 0;
}
@property --tw-enter-scale {
  syntax: "*";
  inherits: false;
  initial-value: 1;
}
@property --tw-enter-translate-x {
  syntax: "*";
  inherits: false;
  initial-value: 0;
}
@property --tw-enter-translate-y {
  syntax: "*";
  inherits: false;
  initial-value: 0;
}
@property --tw-exit-blur {
  syntax: "*";
  inherits: false;
  initial-value: 0;
}
@property --tw-exit-opacity {
  syntax: "*";
  inherits: false;
  initial-value: 1;
}
@property --tw-exit-rotate {
  syntax: "*";
  inherits: false;
  initial-value: 0;
}
@property --tw-exit-scale {
  syntax: "*";
  inherits: false;
  initial-value: 1;
}
@property --tw-exit-translate-x {
  syntax: "*";
  inherits: false;
  initial-value: 0;
}
@property --tw-exit-translate-y {
  syntax: "*";
  inherits: false;
  initial-value: 0;
}
:root {
  color-scheme: dark;
  --background: oklch(.105 0 0);
  --foreground: oklch(.95 0 0);
  --card: oklch(.145 0 0 / .96);
  --popover: oklch(.18 0 0);
  --primary: oklch(.95 0 0);
  --primary-foreground: oklch(.12 0 0);
  --secondary: oklch(.19 0 0);
  --accent: oklch(.24 0 0);
  --muted-foreground: oklch(.62 0 0);
  --border: oklch(.95 0 0 / .13);
  --ring: oklch(.75 0 0);
  --destructive: oklch(.72 .15 25);
  --success: oklch(.76 .12 155);
  --surface-transparent: oklch(.12 0 0 / .90);
  --shadow-panel: 0 12px 40px oklch(0 0 0 / .18);
  --background-shade: oklch(.07 0 0 / .83);
  --line-light: oklch(.95 0 0 / .25);
  --contour-image: url('data:image/webp;base64,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');
}
@layer base {
  * {
    box-sizing: border-box;
    border-color: var(--border);
    letter-spacing: 0;
  }
  body {
    margin: 0;
    background: var(--background);
    color: var(--foreground);
    font-family: var(--font-sans);
    font-size: 14px;
  }
  button,input,textarea {
    font: inherit;
  }
  button {
    cursor: pointer;
  }
  ::selection {
    background: var(--primary);
    color: var(--primary-foreground);
  }
  ::-webkit-scrollbar {
    width: 5px;
    height: 5px;
  }
  ::-webkit-scrollbar-thumb {
    background: var(--accent);
    border-radius: 4px;
  }
}
.v-bg {
  position: fixed;
  inset: 0;
  z-index: -1;
  pointer-events: none;
  background-image: linear-gradient(var(--background-shade),var(--background-shade)),var(--contour-image);
  background-size: cover;
  background-position: center;
}
.v-workspace {
  min-height: 100svh;
  display: grid;
  grid-template-columns: 232px minmax(0,1fr);
}
.v-sidebar {
  background: var(--surface-transparent);
  border-right: 1px solid var(--border);
  padding: 32px 18px 24px;
  position: sticky;
  top: 0;
  height: 100svh;
  display: flex;
  flex-direction: column;
}
.v-sidebar nav {
  margin-top: 48px;
  gap: 8px;
}
.v-sidebar nav button {
  height: 44px;
  justify-content: flex-start;
  font-weight: 500;
  padding: 0 15px;
  border-radius: 6px;
}
.v-brand-logo {
  width: 38px;
  height: 38px;
  object-fit: contain;
  display: block;
}
.v-brand-name {
  font-size: 13px;
  font-weight: 800;
  white-space: nowrap;
}
.v-nav-icon svg {
  width: 17px;
  height: 17px;
}
.v-sidebar-footer {
  margin-top: auto;
  font-size: 10px;
  display: flex;
  gap: 7px;
  align-items: center;
  color: var(--muted-foreground);
}
.v-sidebar-footer>span:last-child {
  margin-left: auto;
}
.v-status-dot,.v-footer i {
  width: 5px;
  height: 5px;
  border-radius: 50%;
  display: inline-block;
  background: var(--success);
}
.v-main {
  width: 100%;
  max-width: 1320px;
  padding: 43px 48px 24px;
  margin: 0 auto;
  align-self: start;
  min-width: 0;
}
.v-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 28px;
  margin-bottom: 32px;
  border-bottom: 1px solid var(--border);
}
.v-page-title {
  font-size: 28px;
  line-height: 1.2;
  font-weight: 600;
}
.v-profile {
  margin-left: auto;
  position: relative;
}
.v-profile>button {
  background: var(--surface-transparent);
  color: var(--foreground);
  padding: 6px 6px 6px 14px;
  height: 45px;
}
.v-profile-copy {
  display: grid;
  text-align: left;
  gap: 3px;
}
.v-profile-name {
  font-size: 11px;
  font-weight: 600;
}
.v-profile-email {
  color: var(--muted-foreground);
  font-size: 9px;
  font-weight: 400;
}
.v-profile-photo {
  display: grid;
  width: 34px;
  height: 34px;
  place-items: center;
  border-radius: 50%;
  border: 1px solid var(--line-light);
  background: var(--secondary);
  color: var(--foreground);
  font-size: 12px;
  font-weight: 600;
}
.v-view section {
  border-radius: 8px;
  background: var(--card);
  box-shadow: var(--shadow-panel);
  padding: 24px;
  margin-top: 24px;
}
.v-view section:first-child {
  margin-top: 0;
}
.v-view section h3 {
  font-size: 15px;
  font-weight: 600;
}
.v-view section>p {
  font-size: 12px;
  line-height: 1.6;
}
.v-view label>span {
  text-transform: none;
  font-size: 11px;
  color: var(--muted-foreground);
}
.v-input {
  display: flex;
  align-items: center;
  background: var(--background);
  border: 1px solid var(--border);
  color: var(--foreground);
  padding: 11px 13px;
  border-radius: 6px;
  font-size: 12px;
  width: 100%;
  outline: none;
  transition: border-color .2s;
  min-height: 43px;
}
.v-input::placeholder {
  color: var(--muted-foreground);
  opacity: .65;
}
.v-input:focus {
  border-color: var(--ring);
}
.v-btn-primary {
  height: 43px;
  padding: 0 18px;
  font-size: 12px;
  font-weight: 650;
  border-radius: 6px;
}
.v-btn-ghost {
  height: 30px;
  padding: 0 10px;
  font-size: 11px;
  background: var(--secondary);
  color: var(--foreground);
  border: 1px solid var(--border);
  border-radius: 5px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}
.v-dropdown {
  background: var(--popover);
  color: var(--foreground);
  max-height: 230px;
  border-color: var(--line-light);
  box-shadow: var(--shadow-panel);
}
.v-dropdown [role=option] {
  min-height: 38px;
  font-size: 12px;
  cursor: pointer;
}
table {
  border-collapse: collapse;
}
th {
  font-size: 10px;
  padding: 12px 16px 12px 0;
  font-weight: 500;
}
td {
  padding: 15px 16px 15px 0 !important;
  font-size: 12px;
}
td:first-child {
  max-width: 260px;
}
tbody tr:hover {
  background: var(--secondary);
}
.v-footer {
  margin-top: 48px;
  padding-top: 20px;
  border-top: 1px solid var(--border);
  display: flex;
  justify-content: space-between;
  font-size: 9px;
  color: var(--muted-foreground);
}
.v-footer>span:last-child {
  display: flex;
  align-items: center;
  gap: 7px;
}
.v-boot {
  position: fixed;
  inset: 0;
  z-index: 999;
  background: var(--background);
  animation: boot-out .45s 1.75s both;
}
.v-boot-inner {
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%,-56px);
  width: 290px;
  text-align: center;
}
.v-boot-logo {
  width: 112px;
  height: 112px;
  display: block;
  margin: auto;
  object-fit: contain;
  animation: logo-in .85s both;
}
.v-boot-title {
  margin-top: 24px;
  font-size: 18px;
  font-weight: 700;
  animation: fade-in .6s .25s both;
}
.v-boot-slogan {
  color: var(--muted-foreground);
  margin-top: 9px;
  font-size: 12px;
  animation: fade-in .6s .4s both;
}
.v-boot-track {
  width: 130px;
  height: 2px;
  margin: 30px auto 14px;
  background: var(--secondary);
  overflow: hidden;
}
.v-boot-track>div {
  height: 100%;
  background: var(--primary);
  transform-origin: left;
  animation: loading 1.7s cubic-bezier(.18,.7,.4,1) both;
}
.v-boot-text {
  font-family: var(--font-mono);
  font-size: 9px;
  color: var(--muted-foreground);
}
.v-boot-edition {
  position: absolute;
  bottom: 28px;
  left: 0;
  right: 0;
  text-align: center;
  font-family: var(--font-mono);
  color: var(--muted-foreground);
  font-size: 9px;
}
.v-spinner {
  width: 14px;
  height: 14px;
  border-radius: 50%;
  border: 2px solid var(--border);
  border-top-color: var(--primary);
  animation: spin .7s linear infinite;
}
.v-view,.v-fade {
  animation: fade-in .35s ease both;
}
.v-toast {
  animation: fade-in .2s both;
  z-index: 60;
}
@keyframes fade-in {
  from {
    opacity: 0;
    transform: translateY(5px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
@keyframes logo-in {
  from {
    opacity: 0;
    transform: scale(.88);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}
@keyframes loading {
  from {
    transform: scaleX(0);
  }
  to {
    transform: scaleX(1);
  }
}
@keyframes boot-out {
  to {
    opacity: 0;
    visibility: hidden;
  }
}
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
@media (min-width:768px) {
  .v-view .grid-cols-5 {
    grid-template-columns: 1.4fr .9fr .9fr 1.2fr auto;
  }
}
@media (max-width:1100px) and (min-width:768px) {
  .v-main {
    padding: 32px 24px;
  }
  .v-view .grid-cols-5 {
    grid-template-columns: repeat(2,minmax(0,1fr));
  }
}
@media (max-width:767px) {
  .v-workspace {
    grid-template-columns: minmax(0,1fr);
  }
  .v-sidebar {
    position: relative;
    height: auto;
    padding: 22px 18px 14px;
    border-right: 0;
    border-bottom: 1px solid var(--border);
  }
  .v-sidebar nav {
    margin-top: 24px;
    grid-template-columns: repeat(4,minmax(0,1fr));
    gap: 4px;
  }
  .v-sidebar nav button {
    padding: 0 5px;
    height: 38px;
    font-size: 11px;
    gap: 6px;
    justify-content: center;
  }
  .v-nav-icon svg {
    width: 13px;
    height: 13px;
  }
  .v-sidebar-footer {
    display: none;
  }
  .v-main {
    padding: 25px 18px 22px;
  }
  .v-header {
    padding-bottom: 22px;
    margin-bottom: 24px;
  }
  .v-page-title {
    font-size: 23px;
  }
  .v-profile-email {
    display: none;
  }
  .v-profile-name {
    font-size: 10px;
  }
  .v-view section {
    padding: 19px;
    margin-top: 20px;
  }
  .v-view section>div {
    margin-top: 20px;
  }
  .v-view .grid-cols-5 {
    grid-template-columns: repeat(2,minmax(0,1fr));
    gap: 15px 12px;
  }
  .v-view .grid-cols-5>label:first-child {
    grid-column: 1/-1;
  }
  .v-view .grid-cols-5>div:last-child {
    grid-column: 1/-1;
  }
  .v-btn-primary {
    width: 100%;
  }
  table {
    min-width: 650px;
  }
  .v-footer {
    margin-top: 32px;
  }
  .v-toast {
    left: 18px;
    right: 18px;
    bottom: 18px;
    text-align: center;
  }
}
@media (prefers-reduced-motion:reduce) {
  *,*::before,*::after {
    animation-duration: .01ms !important;
    animation-delay: 0ms !important;
    scroll-behavior: auto !important;
  }
}
@property --tw-translate-x {
  syntax: "*";
  inherits: false;
  initial-value: 0;
}
@property --tw-translate-y {
  syntax: "*";
  inherits: false;
  initial-value: 0;
}
@property --tw-translate-z {
  syntax: "*";
  inherits: false;
  initial-value: 0;
}
@property --tw-rotate-x {
  syntax: "*";
  inherits: false;
}
@property --tw-rotate-y {
  syntax: "*";
  inherits: false;
}
@property --tw-rotate-z {
  syntax: "*";
  inherits: false;
}
@property --tw-skew-x {
  syntax: "*";
  inherits: false;
}
@property --tw-skew-y {
  syntax: "*";
  inherits: false;
}
@property --tw-space-y-reverse {
  syntax: "*";
  inherits: false;
  initial-value: 0;
}
@property --tw-space-x-reverse {
  syntax: "*";
  inherits: false;
  initial-value: 0;
}
@property --tw-border-style {
  syntax: "*";
  inherits: false;
  initial-value: solid;
}
@property --tw-leading {
  syntax: "*";
  inherits: false;
}
@property --tw-font-weight {
  syntax: "*";
  inherits: false;
}
@property --tw-tracking {
  syntax: "*";
  inherits: false;
}
@property --tw-ordinal {
  syntax: "*";
  inherits: false;
}
@property --tw-slashed-zero {
  syntax: "*";
  inherits: false;
}
@property --tw-numeric-figure {
  syntax: "*";
  inherits: false;
}
@property --tw-numeric-spacing {
  syntax: "*";
  inherits: false;
}
@property --tw-numeric-fraction {
  syntax: "*";
  inherits: false;
}
@property --tw-shadow {
  syntax: "*";
  inherits: false;
  initial-value: 0 0 #0000;
}
@property --tw-shadow-color {
  syntax: "*";
  inherits: false;
}
@property --tw-shadow-alpha {
  syntax: "<percentage>";
  inherits: false;
  initial-value: 100%;
}
@property --tw-inset-shadow {
  syntax: "*";
  inherits: false;
  initial-value: 0 0 #0000;
}
@property --tw-inset-shadow-color {
  syntax: "*";
  inherits: false;
}
@property --tw-inset-shadow-alpha {
  syntax: "<percentage>";
  inherits: false;
  initial-value: 100%;
}
@property --tw-ring-color {
  syntax: "*";
  inherits: false;
}
@property --tw-ring-shadow {
  syntax: "*";
  inherits: false;
  initial-value: 0 0 #0000;
}
@property --tw-inset-ring-color {
  syntax: "*";
  inherits: false;
}
@property --tw-inset-ring-shadow {
  syntax: "*";
  inherits: false;
  initial-value: 0 0 #0000;
}
@property --tw-ring-inset {
  syntax: "*";
  inherits: false;
}
@property --tw-ring-offset-width {
  syntax: "<length>";
  inherits: false;
  initial-value: 0px;
}
@property --tw-ring-offset-color {
  syntax: "*";
  inherits: false;
  initial-value: #fff;
}
@property --tw-ring-offset-shadow {
  syntax: "*";
  inherits: false;
  initial-value: 0 0 #0000;
}
@property --tw-outline-style {
  syntax: "*";
  inherits: false;
  initial-value: solid;
}
@property --tw-blur {
  syntax: "*";
  inherits: false;
}
@property --tw-brightness {
  syntax: "*";
  inherits: false;
}
@property --tw-contrast {
  syntax: "*";
  inherits: false;
}
@property --tw-grayscale {
  syntax: "*";
  inherits: false;
}
@property --tw-hue-rotate {
  syntax: "*";
  inherits: false;
}
@property --tw-invert {
  syntax: "*";
  inherits: false;
}
@property --tw-opacity {
  syntax: "*";
  inherits: false;
}
@property --tw-saturate {
  syntax: "*";
  inherits: false;
}
@property --tw-sepia {
  syntax: "*";
  inherits: false;
}
@property --tw-drop-shadow {
  syntax: "*";
  inherits: false;
}
@property --tw-drop-shadow-color {
  syntax: "*";
  inherits: false;
}
@property --tw-drop-shadow-alpha {
  syntax: "<percentage>";
  inherits: false;
  initial-value: 100%;
}
@property --tw-drop-shadow-size {
  syntax: "*";
  inherits: false;
}
@property --tw-backdrop-blur {
  syntax: "*";
  inherits: false;
}
@property --tw-backdrop-brightness {
  syntax: "*";
  inherits: false;
}
@property --tw-backdrop-contrast {
  syntax: "*";
  inherits: false;
}
@property --tw-backdrop-grayscale {
  syntax: "*";
  inherits: false;
}
@property --tw-backdrop-hue-rotate {
  syntax: "*";
  inherits: false;
}
@property --tw-backdrop-invert {
  syntax: "*";
  inherits: false;
}
@property --tw-backdrop-opacity {
  syntax: "*";
  inherits: false;
}
@property --tw-backdrop-saturate {
  syntax: "*";
  inherits: false;
}
@property --tw-backdrop-sepia {
  syntax: "*";
  inherits: false;
}
@property --tw-duration {
  syntax: "*";
  inherits: false;
}
@property --tw-ease {
  syntax: "*";
  inherits: false;
}
@property --tw-content {
  syntax: "*";
  initial-value: "";
  inherits: false;
}
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
@keyframes pulse {
  50% {
    opacity: 0.5;
  }
}
@keyframes enter {
  from {
    opacity: var(--tw-enter-opacity,1);
    transform: translate3d(var(--tw-enter-translate-x,0),var(--tw-enter-translate-y,0),0)scale3d(var(--tw-enter-scale,1),var(--tw-enter-scale,1),var(--tw-enter-scale,1))rotate(var(--tw-enter-rotate,0));
    filter: blur(var(--tw-enter-blur,0));
  }
}
@keyframes exit {
  to {
    opacity: var(--tw-exit-opacity,1);
    transform: translate3d(var(--tw-exit-translate-x,0),var(--tw-exit-translate-y,0),0)scale3d(var(--tw-exit-scale,1),var(--tw-exit-scale,1),var(--tw-exit-scale,1))rotate(var(--tw-exit-rotate,0));
    filter: blur(var(--tw-exit-blur,0));
  }
}
@keyframes accordion-down {
  from {
    height: 0;
  }
  to {
    height: var(--radix-accordion-content-height,var(--bits-accordion-content-height,var(--reka-accordion-content-height,var(--kb-accordion-content-height,var(--ngp-accordion-content-height,auto)))));
  }
}
@keyframes accordion-up {
  from {
    height: var(--radix-accordion-content-height,var(--bits-accordion-content-height,var(--reka-accordion-content-height,var(--kb-accordion-content-height,var(--ngp-accordion-content-height,auto)))));
  }
  to {
    height: 0;
  }
}
@keyframes caret-blink {
  0%,70%,100% {
    opacity: 1;
  }
  20%,50% {
    opacity: 0;
  }
}
@layer properties {
  @supports ((-webkit-hyphens: none) and (not (margin-trim: inline))) or ((-moz-orient: inline) and (not (color:rgb(from red r g b)))) {
    *, ::before, ::after, ::backdrop {
      --tw-translate-x: 0;
      --tw-translate-y: 0;
      --tw-translate-z: 0;
      --tw-rotate-x: initial;
      --tw-rotate-y: initial;
      --tw-rotate-z: initial;
      --tw-skew-x: initial;
      --tw-skew-y: initial;
      --tw-space-y-reverse: 0;
      --tw-space-x-reverse: 0;
      --tw-border-style: solid;
      --tw-leading: initial;
      --tw-font-weight: initial;
      --tw-tracking: initial;
      --tw-ordinal: initial;
      --tw-slashed-zero: initial;
      --tw-numeric-figure: initial;
      --tw-numeric-spacing: initial;
      --tw-numeric-fraction: initial;
      --tw-shadow: 0 0 #0000;
      --tw-shadow-color: initial;
      --tw-shadow-alpha: 100%;
      --tw-inset-shadow: 0 0 #0000;
      --tw-inset-shadow-color: initial;
      --tw-inset-shadow-alpha: 100%;
      --tw-ring-color: initial;
      --tw-ring-shadow: 0 0 #0000;
      --tw-inset-ring-color: initial;
      --tw-inset-ring-shadow: 0 0 #0000;
      --tw-ring-inset: initial;
      --tw-ring-offset-width: 0px;
      --tw-ring-offset-color: #fff;
      --tw-ring-offset-shadow: 0 0 #0000;
      --tw-outline-style: solid;
      --tw-blur: initial;
      --tw-brightness: initial;
      --tw-contrast: initial;
      --tw-grayscale: initial;
      --tw-hue-rotate: initial;
      --tw-invert: initial;
      --tw-opacity: initial;
      --tw-saturate: initial;
      --tw-sepia: initial;
      --tw-drop-shadow: initial;
      --tw-drop-shadow-color: initial;
      --tw-drop-shadow-alpha: 100%;
      --tw-drop-shadow-size: initial;
      --tw-backdrop-blur: initial;
      --tw-backdrop-brightness: initial;
      --tw-backdrop-contrast: initial;
      --tw-backdrop-grayscale: initial;
      --tw-backdrop-hue-rotate: initial;
      --tw-backdrop-invert: initial;
      --tw-backdrop-opacity: initial;
      --tw-backdrop-saturate: initial;
      --tw-backdrop-sepia: initial;
      --tw-duration: initial;
      --tw-ease: initial;
      --tw-content: "";
      --tw-animation-delay: 0s;
      --tw-animation-direction: normal;
      --tw-animation-duration: initial;
      --tw-animation-fill-mode: none;
      --tw-animation-iteration-count: 1;
      --tw-enter-blur: 0;
      --tw-enter-opacity: 1;
      --tw-enter-rotate: 0;
      --tw-enter-scale: 1;
      --tw-enter-translate-x: 0;
      --tw-enter-translate-y: 0;
      --tw-exit-blur: 0;
      --tw-exit-opacity: 1;
      --tw-exit-rotate: 0;
      --tw-exit-scale: 1;
      --tw-exit-translate-x: 0;
      --tw-exit-translate-y: 0;
    }
  }
}

/* Workspace revision: full-height background, plain zero glyph and account controls. */
html {min-height:100%;background:var(--background)}
body {min-height:100dvh;isolation:isolate;background:transparent}
#root {min-height:100dvh}
.v-bg {z-index:-1;inset:0;min-height:100dvh;height:100%;background-repeat:no-repeat;background-size:cover}
.font-mono,code,pre,.v-boot-text,.v-boot-edition {font-family:Consolas,"Courier New",monospace;font-feature-settings:"zero" 0}
.v-drop-zone {min-height:230px;border:1px dashed var(--ring);border-radius:8px;background:var(--secondary);display:flex;flex-direction:column;align-items:center;justify-content:center;gap:14px;padding:24px;text-align:center}
.v-drop-zone.is-dragging {background:var(--accent);border-color:var(--primary)}
.v-drop-zone>svg {color:var(--muted-foreground);width:32px;height:32px}
.v-drop-zone h4 {font-weight:600;font-size:15px}
.v-file-name {font-size:11px;color:var(--muted-foreground);overflow-wrap:anywhere}
.v-file-button {height:40px;gap:9px;padding:0 16px}
.v-file-button svg {width:16px;height:16px}
.v-loader-code {background:var(--background);border:1px solid var(--border);border-radius:6px;padding:14px;font-size:12px;line-height:1.7;overflow:auto;max-width:100%}
.v-account-trigger {display:flex;gap:10px;align-items:center;border:1px solid var(--border);border-radius:6px;max-width:230px}
.v-account-email {font-size:11px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.v-account-avatar {height:34px;width:34px;flex-shrink:0;display:grid;place-items:center;object-fit:cover;border-radius:50%;background:var(--secondary);border:1px solid var(--border)}
.v-account-overlay {position:fixed;inset:0;z-index:100;background:var(--background-shade);display:flex;align-items:center;justify-content:center;padding:20px;backdrop-filter:blur(7px)}
.v-account-dialog {width:min(100%,480px);max-height:calc(100dvh - 40px);overflow-y:auto;border:1px solid var(--border);border-radius:8px;background:var(--card);box-shadow:var(--shadow-panel);padding:24px}
.v-account-heading {display:flex;justify-content:space-between;gap:12px;align-items:center}
.v-account-heading h3 {font-size:20px;font-weight:650;margin-top:6px}
.v-account-eyebrow {font-size:10px;color:var(--muted-foreground)}
.v-account-close {height:32px;width:32px;font-size:24px;padding:0;flex-shrink:0}
.v-account-section {display:grid;gap:14px;border-top:1px solid var(--border);margin-top:22px;padding-top:20px}
.v-account-section h4 {font-size:12px;font-weight:650}
.v-account-photo-row {display:flex;gap:10px;align-items:center;flex-wrap:wrap}
.v-account-photo-row .v-account-avatar {height:48px;width:48px}
.v-account-check {display:flex;align-items:center;gap:10px;font-size:12px}
.v-account-check input {accent-color:var(--primary);width:16px;height:16px}
.v-account-actions {display:flex;justify-content:space-between;align-items:center;gap:12px;margin-top:24px;padding-top:20px;border-top:1px solid var(--border)}
.v-account-dialog [role=alert] {margin-top:14px;font-size:12px}
@media(max-width:767px){.v-account-overlay{padding:12px}.v-account-dialog{padding:20px;max-height:calc(100dvh - 24px)}.v-account-trigger{max-width:205px}.v-account-email{max-width:140px;font-size:10px}.v-page-title{font-size:21px}.v-header{gap:10px}.v-bg{background-position:center center}.v-workspace{min-height:100dvh}}
@media(prefers-reduced-motion:reduce){*,*::before,*::after{animation:none!important;transition:none!important}.v-boot{display:none}}

.v-left{font-size:10px;color:var(--muted-foreground);font-family:"IBM Plex Mono",monospace;margin-top:2px}
.v-rise{opacity:0;animation:v-rise 1s cubic-bezier(.2,.7,.2,1) var(--d,0s) both}
@keyframes v-rise{from{opacity:0;transform:translateY(14px);filter:blur(6px)}to{opacity:1;transform:none;filter:none}}
@keyframes v-fadeonly{from{opacity:0}to{opacity:1}}
@keyframes v-logo{from{opacity:0;transform:scale(.92);filter:blur(10px)}to{opacity:1;transform:none;filter:drop-shadow(0 0 40px rgba(255,255,255,.35))}}
.v-landing{position:fixed;inset:0;overflow:hidden;background:#000;color:#fff;font-family:Manrope,sans-serif}
.v-landing-bg{position:absolute;inset:0;background:url(data:image/jpeg;base64,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) center/cover no-repeat;animation:v-fadeonly 1.6s ease both}
.v-landing-bg:after{content:"";position:absolute;inset:0;background:linear-gradient(90deg,rgba(0,0,0,.75),rgba(0,0,0,.15) 60%,rgba(0,0,0,.1))}
.v-landing-top{position:absolute;top:36px;left:54px;display:flex;align-items:center;gap:16px}
.v-landing-top img{width:46px;height:46px;object-fit:contain}
.v-landing-top i{width:1px;height:30px;background:rgba(255,255,255,.3)}
.v-landing-top span{letter-spacing:.22em;font-size:20px;font-weight:500}
.v-landing-main{position:relative;height:100%;display:flex;align-items:center;justify-content:space-between;padding:0 7.5vw;gap:40px}
.v-landing-eyebrow{letter-spacing:.32em;text-transform:uppercase;font-size:clamp(11px,1.1vw,17px);line-height:1.7;color:rgba(255,255,255,.85);font-weight:600}
.v-landing h1{margin-top:22px;font-size:clamp(44px,6vw,98px);line-height:.98;font-weight:800;text-transform:uppercase;letter-spacing:-.01em}
.v-landing-sub{margin-top:28px;max-width:560px;font-size:clamp(14px,1.3vw,20px);line-height:1.6;color:rgba(255,255,255,.72)}
.v-landing-cta{margin-top:36px;display:flex;gap:22px;flex-wrap:wrap}
.v-landing-cta button{display:inline-flex;align-items:center;gap:14px;height:68px;padding:0 48px;border-radius:999px;font-size:18px;font-weight:650;cursor:pointer;transition:transform .2s,background .2s,box-shadow .2s}
.v-landing-primary{background:#fff;color:#000;border:0}
.v-landing-primary:hover{transform:translateY(-2px);box-shadow:0 10px 40px rgba(255,255,255,.25)}
.v-landing-ghost{background:rgba(0,0,0,.4);color:#fff;border:1px solid rgba(255,255,255,.25);backdrop-filter:blur(6px)}
.v-landing-ghost:hover{background:rgba(255,255,255,.08);transform:translateY(-2px)}
.v-landing-logo,.v-landing-top img,.v-auth-tl img,.v-auth-brand img{mix-blend-mode:screen}
.v-landing-logo{width:min(26vw,380px);opacity:0;animation:v-logo 1.6s .5s ease both}
@media(max-width:860px){.v-landing-logo{display:none}.v-landing-top{left:24px}.v-landing-main{padding:0 24px}.v-landing-cta button{height:56px;padding:0 30px;font-size:16px}}
.v-auth{position:fixed;inset:0;overflow:auto;display:grid;place-items:center;padding:110px 18px;color:#fff;font-family:Manrope,sans-serif;animation:v-fadeonly .8s ease both}
.v-auth-tl{position:fixed;top:34px;left:56px;display:flex;align-items:center;gap:20px}
.v-auth-tl img{width:40px;height:40px;object-fit:contain}
.v-auth-tl span{letter-spacing:.3em;font-size:17px}
.v-auth-tl i,.v-auth-br i{width:36px;height:1px;background:rgba(255,255,255,.55)}
.v-auth-tr{position:fixed;top:36px;right:46px;text-align:right;font-size:11px;letter-spacing:.25em;line-height:1.75;text-transform:uppercase;color:rgba(255,255,255,.7);padding-right:16px;border-right:1px solid rgba(255,255,255,.5)}
.v-auth-bl{position:fixed;bottom:50px;left:54px;font-size:11px;letter-spacing:.25em;line-height:1.7;text-transform:uppercase;color:rgba(255,255,255,.7);padding-left:22px;border-left:1px solid rgba(255,255,255,.5)}
.v-auth-br{position:fixed;bottom:56px;right:54px;display:flex;align-items:center;gap:14px;font-size:11px;letter-spacing:.2em;color:rgba(255,255,255,.7)}
.v-auth-card{width:100%;max-width:532px;padding:40px 44px;border-radius:14px;border:1px solid rgba(255,255,255,.12);background:rgba(12,12,12,.72);backdrop-filter:blur(14px);box-shadow:0 30px 80px rgba(0,0,0,.6)}
.v-auth-brand{display:grid;justify-items:center;gap:20px;margin-bottom:28px}
.v-auth-brand img{width:66px;height:66px;object-fit:contain;filter:drop-shadow(0 0 18px rgba(255,255,255,.2))}
.v-auth-brand div{letter-spacing:.42em;font-size:19px;font-weight:300}
.v-auth-brand b{font-weight:700}
.v-auth-card h1{font-size:27px;font-weight:650}
.v-auth-sub{margin-top:8px;font-size:15px;color:rgba(255,255,255,.7)}
.v-auth-label{display:block;margin-top:28px;font-size:11px;font-weight:700;letter-spacing:.2em;text-transform:uppercase;color:rgba(255,255,255,.85)}
.v-auth-label+.v-auth-label{margin-top:22px}
.v-auth-field{margin-top:10px;display:flex;align-items:center;gap:14px;height:52px;padding:0 16px;border:1px solid rgba(255,255,255,.14);border-radius:6px;background:rgba(0,0,0,.55);color:rgba(255,255,255,.8);transition:border-color .2s,box-shadow .2s;text-transform:none;letter-spacing:0}
.v-auth-field:focus-within{border-color:rgba(255,255,255,.45);box-shadow:0 0 0 3px rgba(255,255,255,.06)}
.v-auth-field input{flex:1;min-width:0;background:transparent;border:0;outline:none;color:#fff;font-size:15px;font-weight:400}
.v-auth-field input::placeholder{color:rgba(255,255,255,.4)}
.v-auth-eye{background:none;border:0;color:rgba(255,255,255,.8);cursor:pointer;display:grid;place-items:center;padding:4px}
.v-auth-error{margin-top:14px;font-size:12px;color:var(--destructive)}
.v-auth-submit{margin-top:28px;width:100%;height:58px;display:flex;align-items:center;justify-content:center;gap:12px;border:0;border-radius:6px;background:linear-gradient(#fff,#d9d9d9);color:#111;font-weight:700;font-size:16px;letter-spacing:.06em;text-transform:uppercase;cursor:pointer;box-shadow:0 0 28px rgba(255,255,255,.28);transition:transform .2s,box-shadow .2s}
.v-auth-submit:hover{transform:translateY(-1px);box-shadow:0 0 40px rgba(255,255,255,.4)}
.v-auth-switch{margin-top:24px;display:flex;justify-content:center;align-items:center;gap:8px;font-size:13px;color:rgba(255,255,255,.6)}
.v-auth-switch button{display:inline-flex;align-items:center;gap:6px;background:none;border:0;color:#fff;font-size:14px;font-weight:600;cursor:pointer}
.v-auth-switch svg{width:15px;height:15px}
@media(max-width:760px){.v-auth-tr,.v-auth-bl,.v-auth-br{display:none}.v-auth-tl{left:22px;top:24px}.v-auth-card{padding:30px 22px}}
</style>
<style id="v26-ux-layer">
:root{
  --v26-ink:#e9edf5; --v26-dim:#8e97a8; --v26-line:rgba(255,255,255,.1);
  --v26-panel:#0c0e13; --v26-panel2:#13161d; --v26-accent:#cfd8ea;
  --v26-ease:cubic-bezier(.22,1,.36,1);
}
@keyframes v26-fade-up{from{opacity:0;transform:translate3d(0,14px,0)}to{opacity:1;transform:none}}
@keyframes v26-fade-in{from{opacity:0}to{opacity:1}}
@keyframes v26-pop{0%{opacity:0;transform:scale(.94) translateY(10px)}100%{opacity:1;transform:none}}
@keyframes v26-sheen{0%{background-position:-140% 0}100%{background-position:240% 0}}
@keyframes v26-spin{to{transform:rotate(360deg)}}
@keyframes v26-bar{0%{transform:translateX(-100%)}100%{transform:translateX(400%)}}

/* page / view transitions */
.v26-view-enter{animation:v26-fade-up .46s var(--v26-ease) both}
#root > *{animation:v26-fade-in .3s var(--v26-ease) both}
[class*="v-panel"],[class*="v-card"],[class*="v-stat"],section,article{
  transition:transform .35s var(--v26-ease),box-shadow .35s var(--v26-ease),border-color .35s var(--v26-ease);
}
[class*="v-panel"]:hover,[class*="v-card"]:hover{transform:translateY(-2px)}
button,a,input,textarea,select,[role="tab"],[role="button"]{
  transition:background-color .22s var(--v26-ease),border-color .22s var(--v26-ease),
             color .22s var(--v26-ease),transform .18s var(--v26-ease),opacity .22s var(--v26-ease),
             box-shadow .22s var(--v26-ease) !important;
}
button:active,[role="button"]:active{transform:scale(.975)}
@media (prefers-reduced-motion:reduce){*{animation-duration:.01ms !important;transition-duration:.01ms !important}}

/* ---------- themed modal (replaces native confirm/alert) ---------- */
.v26-ovl{position:fixed;inset:0;z-index:2147483000;display:flex;align-items:center;justify-content:center;
  padding:24px;background:rgba(2,3,6,.72);backdrop-filter:blur(10px) saturate(130%);
  animation:v26-fade-in .22s var(--v26-ease) both;font-family:"Manrope",system-ui,sans-serif}
.v26-ovl.v26-out{animation:v26-fade-in .18s var(--v26-ease) reverse both}
.v26-dlg{width:min(430px,100%);border-radius:18px;overflow:hidden;
  background:linear-gradient(180deg,var(--v26-panel2),var(--v26-panel));
  border:1px solid var(--v26-line);
  box-shadow:0 36px 90px -24px rgba(0,0,0,.9),0 0 0 1px rgba(255,255,255,.04) inset;
  animation:v26-pop .34s var(--v26-ease) both}
.v26-dlg-top{height:2px;background:linear-gradient(90deg,transparent,var(--v26-accent),transparent);
  background-size:220% 100%;animation:v26-sheen 2.4s linear infinite}
.v26-dlg-body{padding:24px 24px 8px}
.v26-dlg-brand{display:flex;align-items:center;gap:8px;font-size:10.5px;letter-spacing:.16em;
  text-transform:uppercase;color:var(--v26-dim);margin-bottom:12px}
.v26-dlg-brand i{width:6px;height:6px;border-radius:50%;background:var(--v26-accent);
  box-shadow:0 0 10px var(--v26-accent);display:inline-block}
.v26-dlg h3{margin:0 0 8px;font-size:17px;font-weight:650;color:var(--v26-ink);letter-spacing:-.01em}
.v26-dlg p{margin:0;font-size:13.5px;line-height:1.62;color:var(--v26-dim);white-space:pre-wrap}
.v26-dlg-foot{display:flex;gap:10px;justify-content:flex-end;padding:20px 24px 24px}
.v26-b{appearance:none;border:1px solid var(--v26-line);background:transparent;color:var(--v26-ink);
  font:inherit;font-size:13px;font-weight:560;padding:9px 18px;border-radius:10px;cursor:pointer}
.v26-b:hover{background:rgba(255,255,255,.06);border-color:rgba(255,255,255,.2)}
.v26-b-pri{background:var(--v26-ink);color:#06080c;border-color:transparent}
.v26-b-pri:hover{background:#fff;color:#06080c}
.v26-b-dng{background:#b7303a;color:#fff;border-color:transparent}
.v26-b-dng:hover{background:#cc3942}

/* ---------- toast ---------- */
.v26-toasts{position:fixed;top:18px;right:18px;z-index:2147483100;display:flex;flex-direction:column;
  gap:10px;pointer-events:none;font-family:"Manrope",system-ui,sans-serif}
.v26-toast{pointer-events:auto;min-width:260px;max-width:380px;padding:13px 16px;border-radius:13px;
  background:linear-gradient(180deg,var(--v26-panel2),var(--v26-panel));border:1px solid var(--v26-line);
  box-shadow:0 20px 48px -18px rgba(0,0,0,.85);color:var(--v26-ink);font-size:13px;line-height:1.55;
  display:flex;gap:11px;align-items:flex-start;animation:v26-pop .32s var(--v26-ease) both}
.v26-toast.v26-out{animation:v26-pop .24s var(--v26-ease) reverse both}
.v26-toast i{width:7px;height:7px;border-radius:50%;flex:0 0 auto;margin-top:6px;background:var(--v26-accent);
  box-shadow:0 0 9px var(--v26-accent)}
.v26-toast.err i{background:#e05561;box-shadow:0 0 9px #e05561}
.v26-toast.ok  i{background:#4ec98a;box-shadow:0 0 9px #4ec98a}

/* ---------- build / loader progress overlay ---------- */
.v26-build{position:fixed;inset:0;z-index:2147482900;display:flex;align-items:center;justify-content:center;
  background:rgba(2,3,6,.86);backdrop-filter:blur(14px);animation:v26-fade-in .25s var(--v26-ease) both;
  font-family:"Manrope",system-ui,sans-serif}
.v26-build-in{width:min(380px,90%);text-align:center;animation:v26-pop .4s var(--v26-ease) both}
.v26-build-ring{width:46px;height:46px;margin:0 auto 20px;border-radius:50%;
  border:2px solid rgba(255,255,255,.1);border-top-color:var(--v26-accent);animation:v26-spin .85s linear infinite}
.v26-build h4{margin:0 0 7px;font-size:15.5px;font-weight:620;color:var(--v26-ink)}
.v26-build span{font-size:12.5px;color:var(--v26-dim)}
.v26-build-track{margin-top:20px;height:2px;border-radius:2px;background:rgba(255,255,255,.08);overflow:hidden}
.v26-build-track i{display:block;width:25%;height:100%;border-radius:2px;background:var(--v26-accent);
  animation:v26-bar 1.25s var(--v26-ease) infinite}
</style>
<style id="v-extra">
html,body{margin:0;padding:0}
#root{animation:vFade .45s ease both}
*{transition:background-color .25s ease,color .25s ease,border-color .25s ease,opacity .25s ease,transform .25s ease}
[role=dialog]{animation:vPop .3s cubic-bezier(.2,.8,.2,1) both}
@keyframes vFade{from{opacity:0;transform:translateY(6px)}to{opacity:1;transform:none}}
@keyframes vPop{from{opacity:0;transform:translate(-50%,-48%) scale(.97)}}
#v-loading{position:fixed;inset:0;z-index:99999;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:18px;background:rgba(8,8,8,.82);backdrop-filter:blur(6px);opacity:0;pointer-events:none;transition:opacity .3s ease;font-family:Manrope,sans-serif;color:#e5e5e5;font-size:14px;letter-spacing:.04em}
#v-loading.on{opacity:1;pointer-events:all}
#v-loading .sp{width:54px;height:54px;border-radius:50%;border:4px solid #3a3a3a;border-top-color:#fff;border-right-color:#9a9a9a;animation:vSpin .8s linear infinite}
@keyframes vSpin{to{transform:rotate(360deg)}}
</style><style id="v26-smooth-fix">
.v-bg{position:fixed!important;inset:0!important;height:100vh!important;height:100lvh!important;min-height:0!important;background-size:cover!important;background-attachment:scroll!important;transform:translateZ(0)}
html,body{overflow-x:hidden}
.v-workspace{min-height:100svh}
.v-main{min-width:0}
.v-view{animation:v26-view-in .42s cubic-bezier(.22,1,.36,1) both;will-change:opacity,transform}
@keyframes v26-view-in{from{opacity:0;transform:translate3d(0,8px,0)}to{opacity:1;transform:none}}
.v26-view-enter{animation:none!important}
.v-view section{animation:v26-view-in .5s cubic-bezier(.22,1,.36,1) both}
.v-view section:nth-child(2){animation-delay:.05s}.v-view section:nth-child(3){animation-delay:.1s}
.v-view .overflow-x-auto{max-height:420px;overflow-y:auto;overscroll-behavior:contain}
.v-view thead th{position:sticky;top:0;background:var(--card,var(--background));z-index:1}
button,a,input,select,.v-input{transition:background-color .22s ease,border-color .22s ease,color .22s ease,box-shadow .22s ease,transform .22s cubic-bezier(.22,1,.36,1),opacity .22s ease}
button:active:not(:disabled){transform:scale(.97)}
tbody tr{transition:background-color .2s ease}
.v26-toast,.v26-ovl,.v26-dlg{will-change:opacity,transform}
@media (prefers-reduced-motion:reduce){*{animation-duration:.01ms!important;transition-duration:.01ms!important}}

/* Keep the workspace within the viewport; scroll only real content. */
.v-workspace {
  height: 100dvh;
  min-height: 0;
  overflow: hidden;
}
.v-sidebar { height: 100%; min-height: 0; }
.v-main {
  height: 100%;
  min-height: 0;
  display: flex;
  flex-direction: column;
  align-self: stretch;
}
.v-header { flex-shrink: 0; }
.v-view {
  flex: 1;
  min-height: 0;
  overflow-y: auto;
  overscroll-behavior-y: contain;
}
.v-footer { flex-shrink: 0; margin-top: 24px; }
@media (max-width: 767px) {
  .v-workspace {
    height: auto;
    min-height: 100dvh;
    grid-template-rows: auto minmax(0, 1fr);
    overflow: visible;
  }
  .v-sidebar { height: auto; }
  .v-main { height: auto; }
  .v-view { overflow: visible; }
}

/* Place dropdowns immediately under the field, then reveal vertically. */
[data-radix-popper-content-wrapper]:has(.v-dropdown) {
  transition: none;
}
.v-dropdown {
  width: var(--radix-select-trigger-width);
  transform-origin: top center;
  transition: none;
}
.v-dropdown[data-state="open"] {
  animation: v26-select-down 220ms cubic-bezier(.22, 1, .36, 1) both;
}
.v-dropdown[data-state="closed"] {
  animation: v26-select-up 140ms ease-in both;
}
@keyframes v26-select-down {
  from { opacity: 0; clip-path: inset(0 0 100% 0); }
  to { opacity: 1; clip-path: inset(0 0 0 0); }
}
@keyframes v26-select-up {
  from { opacity: 1; clip-path: inset(0 0 0 0); }
  to { opacity: 0; clip-path: inset(0 0 100% 0); }
}
@media (prefers-reduced-motion: reduce) {
  .v-dropdown[data-state] { animation: none; }
}
</style><style id="discord-login">:root {
  --discord: oklch(0.577 0.209 275.3);
  --discord-hover: oklch(0.627 0.209 275.3);
  --discord-foreground: oklch(1 0 0);
  --discord-focus: oklch(0.78 0.12 275.3);
  --discord-shadow: 0 3px 12px oklch(0 0 0 / 18%);
}
.v-discord-login {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  min-height: 44px;
  height: 44px;
  padding: 0 20px;
  margin-top: 24px;
  border: 1px solid transparent;
  border-radius: 6px;
  background: var(--discord);
  color: var(--discord-foreground);
  font-family: inherit;
  font-size: 14px;
  font-weight: 600;
  letter-spacing: 0;
  text-transform: none;
  box-shadow: var(--discord-shadow);
  cursor: pointer;
  transition: background-color 180ms ease, box-shadow 180ms ease;
}
.v-discord-login:hover {
  background: var(--discord-hover);
  color: var(--discord-foreground);
}
.v-discord-login:focus-visible {
  outline: 2px solid var(--discord-focus);
  outline-offset: 3px;
}
.v-discord-login svg { width: 20px; height: 20px; flex-shrink: 0; }
.v-auth-card .v-discord-login { width: 100%; }
.v-session-error {
  position: fixed;
  top: 16px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 50;
  max-width: calc(100% - 32px);
  color: #f87171;
  background: #0a0a0a;
  padding: 12px 16px;
  border: 1px solid #262626;
  border-radius: 6px;
  font-size: 12px;
}
@media (prefers-reduced-motion: reduce) {
  .v-discord-login { transition: none; }
}</style><style id="v26-theme-styles">
/* v26 Theme & Ambient Leaves Engine */
#v-leaves-canvas {
  position: fixed;
  inset: 0;
  width: 100vw;
  height: 100vh;
  pointer-events: none;
  z-index: 0;
  display: none;
}
body.theme-leaves #v-leaves-canvas {
  display: block;
}
body.theme-leaves .v-bg {
  background-image: radial-gradient(circle at 50% 20%, rgba(255, 255, 255, 0.04) 0%, transparent 70%), linear-gradient(to bottom, #090a0f, #0d0f17) !important;
}
</style></head><body><div id="root"></div><script>(()=>{var uT=Object.create;var{getPrototypeOf:mT,defineProperty:R1,getOwnPropertyNames:dT}=Object;var pT=Object.prototype.hasOwnProperty;var y=(A,M,Z)=>{Z=A!=null?uT(mT(A)):{};let q=M||!A||!A.__esModule?R1(Z,"default",{value:A,enumerable:!0}):Z;for(let z of dT(A))if(!pT.call(q,z))R1(q,z,{get:()=>A[z],enumerable:!0});return q};var J7=(A,M)=>()=>(M||A((M={exports:{}}).exports,M),M.exports);var y1=J7((c)=>{var jV=Symbol.for("react.transitional.element"),cT=Symbol.for("react.portal"),lT=Symbol.for("react.fragment"),iT=Symbol.for("react.strict_mode"),rT=Symbol.for("react.profiler"),sT=Symbol.for("react.consumer"),oT=Symbol.for("react.context"),aT=Symbol.for("react.forward_ref"),nT=Symbol.for("react.suspense"),$T=Symbol.for("react.memo"),k1=Symbol.for("react.lazy"),_T=Symbol.for("react.activity"),H1=Symbol.iterator;function tT(A){if(A===null||typeof A!=="object")return null;return A=H1&&A[H1]||A["@@iterator"],typeof A==="function"?A:null}var C1={isMounted:function(){return!1},enqueueForceUpdate:function(){},enqueueReplaceState:function(){},enqueueSetState:function(){}},b1=Object.assign,S1={};function jq(A,M,Z){this.props=A,this.context=M,this.refs=S1,this.updater=Z||C1}jq.prototype.isReactComponent={};jq.prototype.setState=function(A,M){if(typeof A!=="object"&&typeof A!=="function"&&A!=null)throw Error("takes an object of state variables to update or a function which returns an object of state variables.");this.updater.enqueueSetState(this,A,M,"setState")};jq.prototype.forceUpdate=function(A){this.updater.enqueueForceUpdate(this,A,"forceUpdate")};function P1(){}P1.prototype=jq.prototype;function XV(A,M,Z){this.props=A,this.context=M,this.refs=S1,this.updater=Z||C1}var OV=XV.prototype=new P1;OV.constructor=XV;b1(OV,jq.prototype);OV.isPureReactComponent=!0;var F1=Array.isArray;function NV(){}var DA={H:null,A:null,T:null,S:null},x1=Object.prototype.hasOwnProperty;function EV(A,M,Z){var q=Z.ref;return{$$typeof:jV,type:A,key:M,ref:q!==void 0?q:null,props:Z}}function eT(A,M){return EV(A.type,M,A.props)}function RV(A){return typeof A==="object"&&A!==null&&A.$$typeof===jV}function AK(A){var M={"=":"=0",":":"=2"};return"$"+A.replace(/[=:]/g,function(Z){return M[Z]})}var L1=/\/+/g;function DV(A,M){return typeof A==="object"&&A!==null&&A.key!=null?AK(""+A.key):M.toString(36)}function MK(A){switch(A.status){case"fulfilled":return A.value;case"rejected":throw A.reason;default:switch(typeof A.status==="string"?A.then(NV,NV):(A.status="pending",A.then(function(M){A.status==="pending"&&(A.status="fulfilled",A.value=M)},function(M){A.status==="pending"&&(A.status="rejected",A.reason=M)})),A.status){case"fulfilled":return A.value;case"rejected":throw A.reason}}throw A}function Nq(A,M,Z,q,z){var Y=typeof A;if(Y==="undefined"||Y==="boolean")A=null;var V=!1;if(A===null)V=!0;else switch(Y){case"bigint":case"string":case"number":V=!0;break;case"object":switch(A.$$typeof){case jV:case cT:V=!0;break;case k1:return V=A._init,Nq(V(A._payload),M,Z,q,z)}}if(V)return z=z(A),V=q===""?"."+DV(A,0):q,F1(z)?(Z="",V!=null&&(Z=V.replace(L1,"$&/")+"/"),Nq(z,M,Z,"",function(B){return B})):z!=null&&(RV(z)&&(z=eT(z,Z+(z.key==null||A&&A.key===z.key?"":(""+z.key).replace(L1,"$&/")+"/")+V)),M.push(z)),1;V=0;var Q=q===""?".":q+":";if(F1(A))for(var U=0;U<A.length;U++)q=A[U],Y=Q+DV(q,U),V+=Nq(q,M,Z,Y,z);else if(U=tT(A),typeof U==="function")for(A=U.call(A),U=0;!(q=A.next()).done;)q=q.value,Y=Q+DV(q,U++),V+=Nq(q,M,Z,Y,z);else if(Y==="object"){if(typeof A.then==="function")return Nq(MK(A),M,Z,q,z);throw M=String(A),Error("Objects are not valid as a React child (found: "+(M==="[object Object]"?"object with keys {"+Object.keys(A).join(", ")+"}":M)+"). If you meant to render a collection of children, use an array instead.")}return V}function nY(A,M,Z){if(A==null)return A;var q=[],z=0;return Nq(A,q,"","",function(Y){return M.call(Z,Y,z++)}),q}function ZK(A){if(A._status===-1){var M=A._result;M=M(),M.then(function(Z){if(A._status===0||A._status===-1)A._status=1,A._result=Z},function(Z){if(A._status===0||A._status===-1)A._status=2,A._result=Z}),A._status===-1&&(A._status=0,A._result=M)}if(A._status===1)return A._result.default;throw A._result}var w1=typeof reportError==="function"?reportError:function(A){if(typeof window==="object"&&typeof window.ErrorEvent==="function"){var M=new window.ErrorEvent("error",{bubbles:!0,cancelable:!0,message:typeof A==="object"&&A!==null&&typeof A.message==="string"?String(A.message):String(A),error:A});if(!window.dispatchEvent(M))return}else if(typeof process==="object"&&typeof process.emit==="function"){process.emit("uncaughtException",A);return}console.error(A)},qK={map:nY,forEach:function(A,M,Z){nY(A,function(){M.apply(this,arguments)},Z)},count:function(A){var M=0;return nY(A,function(){M++}),M},toArray:function(A){return nY(A,function(M){return M})||[]},only:function(A){if(!RV(A))throw Error("React.Children.only expected to receive a single React element child.");return A}};c.Activity=_T;c.Children=qK;c.Component=jq;c.Fragment=lT;c.Profiler=rT;c.PureComponent=XV;c.StrictMode=iT;c.Suspense=nT;c.__CLIENT_INTERNALS_DO_NOT_USE_OR_WARN_USERS_THEY_CANNOT_UPGRADE=DA;c.__COMPILER_RUNTIME={__proto__:null,c:function(A){return DA.H.useMemoCache(A)}};c.cache=function(A){return function(){return A.apply(null,arguments)}};c.cacheSignal=function(){return null};c.cloneElement=function(A,M,Z){if(A===null||A===void 0)throw Error("The argument must be a React element, but you passed "+A+".");var q=b1({},A.props),z=A.key;if(M!=null)for(Y in M.key!==void 0&&(z=""+M.key),M)!x1.call(M,Y)||Y==="key"||Y==="__self"||Y==="__source"||Y==="ref"&&M.ref===void 0||(q[Y]=M[Y]);var Y=arguments.length-2;if(Y===1)q.children=Z;else if(1<Y){for(var V=Array(Y),Q=0;Q<Y;Q++)V[Q]=arguments[Q+2];q.children=V}return EV(A.type,z,q)};c.createContext=function(A){return A={$$typeof:oT,_currentValue:A,_currentValue2:A,_threadCount:0,Provider:null,Consumer:null},A.Provider=A,A.Consumer={$$typeof:sT,_context:A},A};c.createElement=function(A,M,Z){var q,z={},Y=null;if(M!=null)for(q in M.key!==void 0&&(Y=""+M.key),M)x1.call(M,q)&&q!=="key"&&q!=="__self"&&q!=="__source"&&(z[q]=M[q]);var V=arguments.length-2;if(V===1)z.children=Z;else if(1<V){for(var Q=Array(V),U=0;U<V;U++)Q[U]=arguments[U+2];z.children=Q}if(A&&A.defaultProps)for(q in V=A.defaultProps,V)z[q]===void 0&&(z[q]=V[q]);return EV(A,Y,z)};c.createRef=function(){return{current:null}};c.forwardRef=function(A){return{$$typeof:aT,render:A}};c.isValidElement=RV;c.lazy=function(A){return{$$typeof:k1,_payload:{_status:-1,_result:A},_init:ZK}};c.memo=function(A,M){return{$$typeof:$T,type:A,compare:M===void 0?null:M}};c.startTransition=function(A){var M=DA.T,Z={};DA.T=Z;try{var q=A(),z=DA.S;z!==null&&z(Z,q),typeof q==="object"&&q!==null&&typeof q.then==="function"&&q.then(NV,w1)}catch(Y){w1(Y)}finally{M!==null&&Z.types!==null&&(M.types=Z.types),DA.T=M}};c.unstable_useCacheRefresh=function(){return DA.H.useCacheRefresh()};c.use=function(A){return DA.H.use(A)};c.useActionState=function(A,M,Z){return DA.H.useActionState(A,M,Z)};c.useCallback=function(A,M){return DA.H.useCallback(A,M)};c.useContext=function(A){return DA.H.useContext(A)};c.useDebugValue=function(){};c.useDeferredValue=function(A,M){return DA.H.useDeferredValue(A,M)};c.useEffect=function(A,M){return DA.H.useEffect(A,M)};c.useEffectEvent=function(A){return DA.H.useEffectEvent(A)};c.useId=function(){return DA.H.useId()};c.useImperativeHandle=function(A,M,Z){return DA.H.useImperativeHandle(A,M,Z)};c.useInsertionEffect=function(A,M){return DA.H.useInsertionEffect(A,M)};c.useLayoutEffect=function(A,M){return DA.H.useLayoutEffect(A,M)};c.useMemo=function(A,M){return DA.H.useMemo(A,M)};c.useOptimistic=function(A,M){return DA.H.useOptimistic(A,M)};c.useReducer=function(A,M,Z){return DA.H.useReducer(A,M,Z)};c.useRef=function(A){return DA.H.useRef(A)};c.useState=function(A){return DA.H.useState(A)};c.useSyncExternalStore=function(A,M,Z){return DA.H.useSyncExternalStore(A,M,Z)};c.useTransition=function(){return DA.H.useTransition()};c.version="19.2.8"});var l=J7((wO,h1)=>{h1.exports=y1()});var p1=J7((HA)=>{function FV(A,M){var Z=A.length;A.push(M);A:for(;0<Z;){var q=Z-1>>>1,z=A[q];if(0<$Y(z,M))A[q]=M,A[Z]=z,Z=q;else break A}}function T7(A){return A.length===0?null:A[0]}function A9(A){if(A.length===0)return null;var M=A[0],Z=A.pop();if(Z!==M){A[0]=Z;A:for(var q=0,z=A.length,Y=z>>>1;q<Y;){var V=2*(q+1)-1,Q=A[V],U=V+1,B=A[U];if(0>$Y(Q,Z))U<z&&0>$Y(B,Q)?(A[q]=B,A[U]=Z,q=U):(A[q]=Q,A[V]=Z,q=V);else if(U<z&&0>$Y(B,Z))A[q]=B,A[U]=Z,q=U;else break A}}return M}function $Y(A,M){var Z=A.sortIndex-M.sortIndex;return Z!==0?Z:A.id-M.id}HA.unstable_now=void 0;if(typeof performance==="object"&&typeof performance.now==="function")LV=performance,HA.unstable_now=function(){return LV.now()};else _Y=Date,wV=_Y.now(),HA.unstable_now=function(){return _Y.now()-wV};var LV,_Y,wV,w7=[],t7=[],zK=1,uM=null,zM=3,kV=!1,bz=!1,Sz=!1,bV=!1,f1=typeof setTimeout==="function"?setTimeout:null,g1=typeof clearTimeout==="function"?clearTimeout:null,v1=typeof setImmediate<"u"?setImmediate:null;function tY(A){for(var M=T7(t7);M!==null;){if(M.callback===null)A9(t7);else if(M.startTime<=A)A9(t7),M.sortIndex=M.expirationTime,FV(w7,M);else break;M=T7(t7)}}function SV(A){if(Sz=!1,tY(A),!bz)if(T7(w7)!==null)bz=!0,Oq||(Oq=!0,Xq());else{var M=T7(t7);M!==null&&PV(SV,M.startTime-A)}}var Oq=!1,Pz=-1,u1=5,m1=-1;function d1(){return bV?!0:HA.unstable_now()-m1<u1?!1:!0}function HV(){if(bV=!1,Oq){var A=HA.unstable_now();m1=A;var M=!0;try{A:{bz=!1,Sz&&(Sz=!1,g1(Pz),Pz=-1),kV=!0;var Z=zM;try{M:{tY(A);for(uM=T7(w7);uM!==null&&!(uM.expirationTime>A&&d1());){var q=uM.callback;if(typeof q==="function"){uM.callback=null,zM=uM.priorityLevel;var z=q(uM.expirationTime<=A);if(A=HA.unstable_now(),typeof z==="function"){uM.callback=z,tY(A),M=!0;break M}uM===T7(w7)&&A9(w7),tY(A)}else A9(w7);uM=T7(w7)}if(uM!==null)M=!0;else{var Y=T7(t7);Y!==null&&PV(SV,Y.startTime-A),M=!1}}break A}finally{uM=null,zM=Z,kV=!1}M=void 0}}finally{M?Xq():Oq=!1}}}var Xq;if(typeof v1==="function")Xq=function(){v1(HV)};else if(typeof MessageChannel<"u")eY=new MessageChannel,CV=eY.port2,eY.port1.onmessage=HV,Xq=function(){CV.postMessage(null)};else Xq=function(){f1(HV,0)};var eY,CV;function PV(A,M){Pz=f1(function(){A(HA.unstable_now())},M)}HA.unstable_IdlePriority=5;HA.unstable_ImmediatePriority=1;HA.unstable_LowPriority=4;HA.unstable_NormalPriority=3;HA.unstable_Profiling=null;HA.unstable_UserBlockingPriority=2;HA.unstable_cancelCallback=function(A){A.callback=null};HA.unstable_forceFrameRate=function(A){0>A||125<A?console.error("forceFrameRate takes a positive int between 0 and 125, forcing frame rates higher than 125 fps is not supported"):u1=0<A?Math.floor(1000/A):5};HA.unstable_getCurrentPriorityLevel=function(){return zM};HA.unstable_next=function(A){switch(zM){case 1:case 2:case 3:var M=3;break;default:M=zM}var Z=zM;zM=M;try{return A()}finally{zM=Z}};HA.unstable_requestPaint=function(){bV=!0};HA.unstable_runWithPriority=function(A,M){switch(A){case 1:case 2:case 3:case 4:case 5:break;default:A=3}var Z=zM;zM=A;try{return M()}finally{zM=Z}};HA.unstable_scheduleCallback=function(A,M,Z){var q=HA.unstable_now();switch(typeof Z==="object"&&Z!==null?(Z=Z.delay,Z=typeof Z==="number"&&0<Z?q+Z:q):Z=q,A){case 1:var z=-1;break;case 2:z=250;break;case 5:z=1073741823;break;case 4:z=1e4;break;default:z=5000}return z=Z+z,A={id:zK++,callback:M,priorityLevel:A,startTime:Z,expirationTime:z,sortIndex:-1},Z>q?(A.sortIndex=Z,FV(t7,A),T7(w7)===null&&A===T7(t7)&&(Sz?(g1(Pz),Pz=-1):Sz=!0,PV(SV,Z-q))):(A.sortIndex=z,FV(w7,A),bz||kV||(bz=!0,Oq||(Oq=!0,Xq()))),A};HA.unstable_shouldYield=d1;HA.unstable_wrapCallback=function(A){var M=zM;return function(){var Z=zM;zM=M;try{return A.apply(this,arguments)}finally{zM=Z}}}});var l1=J7((CO,c1)=>{c1.exports=p1()});var r1=J7((UM)=>{var YK=l();function i1(A){var M="https://react.dev/errors/"+A;if(1<arguments.length){M+="?args[]="+encodeURIComponent(arguments[1]);for(var Z=2;Z<arguments.length;Z++)M+="&args[]="+encodeURIComponent(arguments[Z])}return"Minified React error #"+A+"; visit "+M+" for the full message or use the non-minified dev environment for full errors and additional helpful warnings."}function e7(){}var QM={d:{f:e7,r:function(){throw Error(i1(522))},D:e7,C:e7,L:e7,m:e7,X:e7,S:e7,M:e7},p:0,findDOMNode:null},VK=Symbol.for("react.portal");function QK(A,M,Z){var q=3<arguments.length&&arguments[3]!==void 0?arguments[3]:null;return{$$typeof:VK,key:q==null?null:""+q,children:A,containerInfo:M,implementation:Z}}var xz=YK.__CLIENT_INTERNALS_DO_NOT_USE_OR_WARN_USERS_THEY_CANNOT_UPGRADE;function M9(A,M){if(A==="font")return"";if(typeof M==="string")return M==="use-credentials"?M:""}UM.__DOM_INTERNALS_DO_NOT_USE_OR_WARN_USERS_THEY_CANNOT_UPGRADE=QM;UM.createPortal=function(A,M){var Z=2<arguments.length&&arguments[2]!==void 0?arguments[2]:null;if(!M||M.nodeType!==1&&M.nodeType!==9&&M.nodeType!==11)throw Error(i1(299));return QK(A,M,null,Z)};UM.flushSync=function(A){var M=xz.T,Z=QM.p;try{if(xz.T=null,QM.p=2,A)return A()}finally{xz.T=M,QM.p=Z,QM.d.f()}};UM.preconnect=function(A,M){typeof A==="string"&&(M?(M=M.crossOrigin,M=typeof M==="string"?M==="use-credentials"?M:"":void 0):M=null,QM.d.C(A,M))};UM.prefetchDNS=function(A){typeof A==="string"&&QM.d.D(A)};UM.preinit=function(A,M){if(typeof A==="string"&&M&&typeof M.as==="string"){var Z=M.as,q=M9(Z,M.crossOrigin),z=typeof M.integrity==="string"?M.integrity:void 0,Y=typeof M.fetchPriority==="string"?M.fetchPriority:void 0;Z==="style"?QM.d.S(A,typeof M.precedence==="string"?M.precedence:void 0,{crossOrigin:q,integrity:z,fetchPriority:Y}):Z==="script"&&QM.d.X(A,{crossOrigin:q,integrity:z,fetchPriority:Y,nonce:typeof M.nonce==="string"?M.nonce:void 0})}};UM.preinitModule=function(A,M){if(typeof A==="string")if(typeof M==="object"&&M!==null){if(M.as==null||M.as==="script"){var Z=M9(M.as,M.crossOrigin);QM.d.M(A,{crossOrigin:Z,integrity:typeof M.integrity==="string"?M.integrity:void 0,nonce:typeof M.nonce==="string"?M.nonce:void 0})}}else M==null&&QM.d.M(A)};UM.preload=function(A,M){if(typeof A==="string"&&typeof M==="object"&&M!==null&&typeof M.as==="string"){var Z=M.as,q=M9(Z,M.crossOrigin);QM.d.L(A,Z,{crossOrigin:q,integrity:typeof M.integrity==="string"?M.integrity:void 0,nonce:typeof M.nonce==="string"?M.nonce:void 0,type:typeof M.type==="string"?M.type:void 0,fetchPriority:typeof M.fetchPriority==="string"?M.fetchPriority:void 0,referrerPolicy:typeof M.referrerPolicy==="string"?M.referrerPolicy:void 0,imageSrcSet:typeof M.imageSrcSet==="string"?M.imageSrcSet:void 0,imageSizes:typeof M.imageSizes==="string"?M.imageSizes:void 0,media:typeof M.media==="string"?M.media:void 0})}};UM.preloadModule=function(A,M){if(typeof A==="string")if(M){var Z=M9(M.as,M.crossOrigin);QM.d.m(A,{as:typeof M.as==="string"&&M.as!=="script"?M.as:void 0,crossOrigin:Z,integrity:typeof M.integrity==="string"?M.integrity:void 0})}else QM.d.m(A)};UM.requestFormReset=function(A){QM.d.r(A)};UM.unstable_batchedUpdates=function(A,M){return A(M)};UM.useFormState=function(A,M,Z){return xz.H.useFormState(A,M,Z)};UM.useFormStatus=function(){return xz.H.useHostTransitionStatus()};UM.version="19.2.8"});var Eq=J7((SO,o1)=>{function s1(){if(typeof __REACT_DEVTOOLS_GLOBAL_HOOK__>"u"||typeof __REACT_DEVTOOLS_GLOBAL_HOOK__.checkDCE!=="function")return;try{__REACT_DEVTOOLS_GLOBAL_HOOK__.checkDCE(s1)}catch(A){console.error(A)}}s1(),o1.exports=r1()});var qW=J7((H3)=>{var cA=l1(),NG=l(),UK=Eq();function w(A){var M="https://react.dev/errors/"+A;if(1<arguments.length){M+="?args[]="+encodeURIComponent(arguments[1]);for(var Z=2;Z<arguments.length;Z++)M+="&args[]="+encodeURIComponent(arguments[Z])}return"Minified React error #"+A+"; visit "+M+" for the full message or use the non-minified dev environment for full errors and additional helpful warnings."}function jG(A){return!(!A||A.nodeType!==1&&A.nodeType!==9&&A.nodeType!==11)}function EY(A){var M=A,Z=A;if(A.alternate)for(;M.return;)M=M.return;else{A=M;do M=A,(M.flags&4098)!==0&&(Z=M.return),A=M.return;while(A)}return M.tag===3?Z:null}function XG(A){if(A.tag===13){var M=A.memoizedState;if(M===null&&(A=A.alternate,A!==null&&(M=A.memoizedState)),M!==null)return M.dehydrated}return null}function OG(A){if(A.tag===31){var M=A.memoizedState;if(M===null&&(A=A.alternate,A!==null&&(M=A.memoizedState)),M!==null)return M.dehydrated}return null}function a1(A){if(EY(A)!==A)throw Error(w(188))}function BK(A){var M=A.alternate;if(!M){if(M=EY(A),M===null)throw Error(w(188));return M!==A?null:A}for(var Z=A,q=M;;){var z=Z.return;if(z===null)break;var Y=z.alternate;if(Y===null){if(q=z.return,q!==null){Z=q;continue}break}if(z.child===Y.child){for(Y=z.child;Y;){if(Y===Z)return a1(z),A;if(Y===q)return a1(z),M;Y=Y.sibling}throw Error(w(188))}if(Z.return!==q.return)Z=z,q=Y;else{for(var V=!1,Q=z.child;Q;){if(Q===Z){V=!0,Z=z,q=Y;break}if(Q===q){V=!0,q=z,Z=Y;break}Q=Q.sibling}if(!V){for(Q=Y.child;Q;){if(Q===Z){V=!0,Z=Y,q=z;break}if(Q===q){V=!0,q=Y,Z=z;break}Q=Q.sibling}if(!V)throw Error(w(189))}}if(Z.alternate!==q)throw Error(w(190))}if(Z.tag!==3)throw Error(w(188));return Z.stateNode.current===Z?A:M}function EG(A){var M=A.tag;if(M===5||M===26||M===27||M===6)return A;for(A=A.child;A!==null;){if(M=EG(A),M!==null)return M;A=A.sibling}return null}var XA=Object.assign,GK=Symbol.for("react.element"),Z9=Symbol.for("react.transitional.element"),mz=Symbol.for("react.portal"),kq=Symbol.for("react.fragment"),RG=Symbol.for("react.strict_mode"),G2=Symbol.for("react.profiler"),HG=Symbol.for("react.consumer"),h7=Symbol.for("react.context"),QQ=Symbol.for("react.forward_ref"),I2=Symbol.for("react.suspense"),W2=Symbol.for("react.suspense_list"),UQ=Symbol.for("react.memo"),AZ=Symbol.for("react.lazy"),J2=Symbol.for("react.activity"),IK=Symbol.for("react.memo_cache_sentinel"),n1=Symbol.iterator;function yz(A){if(A===null||typeof A!=="object")return null;return A=n1&&A[n1]||A["@@iterator"],typeof A==="function"?A:null}var WK=Symbol.for("react.client.reference");function T2(A){if(A==null)return null;if(typeof A==="function")return A.$$typeof===WK?null:A.displayName||A.name||null;if(typeof A==="string")return A;switch(A){case kq:return"Fragment";case G2:return"Profiler";case RG:return"StrictMode";case I2:return"Suspense";case W2:return"SuspenseList";case J2:return"Activity"}if(typeof A==="object")switch(A.$$typeof){case mz:return"Portal";case h7:return A.displayName||"Context";case HG:return(A._context.displayName||"Context")+".Consumer";case QQ:var M=A.render;return A=A.displayName,A||(A=M.displayName||M.name||"",A=A!==""?"ForwardRef("+A+")":"ForwardRef"),A;case UQ:return M=A.displayName||null,M!==null?M:T2(A.type)||"Memo";case AZ:M=A._payload,A=A._init;try{return T2(A(M))}catch(Z){}}return null}var dz=Array.isArray,f=NG.__CLIENT_INTERNALS_DO_NOT_USE_OR_WARN_USERS_THEY_CANNOT_UPGRADE,zA=UK.__DOM_INTERNALS_DO_NOT_USE_OR_WARN_USERS_THEY_CANNOT_UPGRADE,dZ={pending:!1,data:null,method:null,action:null},K2=[],Cq=-1;function X7(A){return{current:A}}function sA(A){0>Cq||(A.current=K2[Cq],K2[Cq]=null,Cq--)}function TA(A,M){Cq++,K2[Cq]=A.current,A.current=M}var j7=X7(null),QY=X7(null),IZ=X7(null),x9=X7(null);function y9(A,M){switch(TA(IZ,M),TA(QY,A),TA(j7,null),M.nodeType){case 9:case 11:A=(A=M.documentElement)?(A=A.namespaceURI)?AG(A):0:0;break;default:if(A=M.tagName,M=M.namespaceURI)M=AG(M),A=l0(M,A);else switch(A){case"svg":A=1;break;case"math":A=2;break;default:A=0}}sA(j7),TA(j7,A)}function sq(){sA(j7),sA(QY),sA(IZ)}function D2(A){A.memoizedState!==null&&TA(x9,A);var M=j7.current,Z=l0(M,A.type);M!==Z&&(TA(QY,A),TA(j7,Z))}function h9(A){QY.current===A&&(sA(j7),sA(QY)),x9.current===A&&(sA(x9),jY._currentValue=dZ)}var xV,$1;function vZ(A){if(xV===void 0)try{throw Error()}catch(Z){var M=Z.stack.trim().match(/\n( *(at )?)/);xV=M&&M[1]||"",$1=-1<Z.stack.indexOf(`
    at`)?" (<anonymous>)":-1<Z.stack.indexOf("@")?"@unknown:0:0":""}return`
`+xV+A+$1}var yV=!1;function hV(A,M){if(!A||yV)return"";yV=!0;var Z=Error.prepareStackTrace;Error.prepareStackTrace=void 0;try{var q={DetermineComponentFrameRoot:function(){try{if(M){var J=function(){throw Error()};if(Object.defineProperty(J.prototype,"props",{set:function(){throw Error()}}),typeof Reflect==="object"&&Reflect.construct){try{Reflect.construct(J,[])}catch(K){var I=K}Reflect.construct(A,[],J)}else{try{J.call()}catch(K){I=K}A.call(J.prototype)}}else{try{throw Error()}catch(K){I=K}(J=A())&&typeof J.catch==="function"&&J.catch(function(){})}}catch(K){if(K&&I&&typeof K.stack==="string")return[K.stack,I.stack]}return[null,null]}};q.DetermineComponentFrameRoot.displayName="DetermineComponentFrameRoot";var z=Object.getOwnPropertyDescriptor(q.DetermineComponentFrameRoot,"name");z&&z.configurable&&Object.defineProperty(q.DetermineComponentFrameRoot,"name",{value:"DetermineComponentFrameRoot"});var Y=q.DetermineComponentFrameRoot(),V=Y[0],Q=Y[1];if(V&&Q){var U=V.split(`
`),B=Q.split(`
`);for(z=q=0;q<U.length&&!U[q].includes("DetermineComponentFrameRoot");)q++;for(;z<B.length&&!B[z].includes("DetermineComponentFrameRoot");)z++;if(q===U.length||z===B.length)for(q=U.length-1,z=B.length-1;1<=q&&0<=z&&U[q]!==B[z];)z--;for(;1<=q&&0<=z;q--,z--)if(U[q]!==B[z]){if(q!==1||z!==1)do if(q--,z--,0>z||U[q]!==B[z]){var W=`
`+U[q].replace(" at new "," at ");return A.displayName&&W.includes("<anonymous>")&&(W=W.replace("<anonymous>",A.displayName)),W}while(1<=q&&0<=z);break}}}finally{yV=!1,Error.prepareStackTrace=Z}return(Z=A?A.displayName||A.name:"")?vZ(Z):""}function JK(A,M){switch(A.tag){case 26:case 27:case 5:return vZ(A.type);case 16:return vZ("Lazy");case 13:return A.child!==M&&M!==null?vZ("Suspense Fallback"):vZ("Suspense");case 19:return vZ("SuspenseList");case 0:case 15:return hV(A.type,!1);case 11:return hV(A.type.render,!1);case 1:return hV(A.type,!0);case 31:return vZ("Activity");default:return""}}function _1(A){try{var M="",Z=null;do M+=JK(A,Z),Z=A,A=A.return;while(A);return M}catch(q){return`
Error generating stack: `+q.message+`
`+q.stack}}var N2=Object.prototype.hasOwnProperty,BQ=cA.unstable_scheduleCallback,vV=cA.unstable_cancelCallback,TK=cA.unstable_shouldYield,KK=cA.unstable_requestPaint,CM=cA.unstable_now,DK=cA.unstable_getCurrentPriorityLevel,FG=cA.unstable_ImmediatePriority,LG=cA.unstable_UserBlockingPriority,v9=cA.unstable_NormalPriority,NK=cA.unstable_LowPriority,wG=cA.unstable_IdlePriority,jK=cA.log,XK=cA.unstable_setDisableYieldValue,RY=null,bM=null;function VZ(A){if(typeof jK==="function"&&XK(A),bM&&typeof bM.setStrictMode==="function")try{bM.setStrictMode(RY,A)}catch(M){}}var SM=Math.clz32?Math.clz32:RK,OK=Math.log,EK=Math.LN2;function RK(A){return A>>>=0,A===0?32:31-(OK(A)/EK|0)|0}var q9=256,z9=262144,Y9=4194304;function fZ(A){var M=A&42;if(M!==0)return M;switch(A&-A){case 1:return 1;case 2:return 2;case 4:return 4;case 8:return 8;case 16:return 16;case 32:return 32;case 64:return 64;case 128:return 128;case 256:case 512:case 1024:case 2048:case 4096:case 8192:case 16384:case 32768:case 65536:case 131072:return A&261888;case 262144:case 524288:case 1048576:case 2097152:return A&3932160;case 4194304:case 8388608:case 16777216:case 33554432:return A&62914560;case 67108864:return 67108864;case 134217728:return 134217728;case 268435456:return 268435456;case 536870912:return 536870912;case 1073741824:return 0;default:return A}}function Q3(A,M,Z){var q=A.pendingLanes;if(q===0)return 0;var z=0,Y=A.suspendedLanes,V=A.pingedLanes;A=A.warmLanes;var Q=q&134217727;return Q!==0?(q=Q&~Y,q!==0?z=fZ(q):(V&=Q,V!==0?z=fZ(V):Z||(Z=Q&~A,Z!==0&&(z=fZ(Z))))):(Q=q&~Y,Q!==0?z=fZ(Q):V!==0?z=fZ(V):Z||(Z=q&~A,Z!==0&&(z=fZ(Z)))),z===0?0:M!==0&&M!==z&&(M&Y)===0&&(Y=z&-z,Z=M&-M,Y>=Z||Y===32&&(Z&4194048)!==0)?M:z}function HY(A,M){return(A.pendingLanes&~(A.suspendedLanes&~A.pingedLanes)&M)===0}function HK(A,M){switch(A){case 1:case 2:case 4:case 8:case 64:return M+250;case 16:case 32:case 128:case 256:case 512:case 1024:case 2048:case 4096:case 8192:case 16384:case 32768:case 65536:case 131072:case 262144:case 524288:case 1048576:case 2097152:return M+5000;case 4194304:case 8388608:case 16777216:case 33554432:return-1;case 67108864:case 134217728:case 268435456:case 536870912:case 1073741824:return-1;default:return-1}}function kG(){var A=Y9;return Y9<<=1,(Y9&62914560)===0&&(Y9=4194304),A}function fV(A){for(var M=[],Z=0;31>Z;Z++)M.push(A);return M}function FY(A,M){A.pendingLanes|=M,M!==268435456&&(A.suspendedLanes=0,A.pingedLanes=0,A.warmLanes=0)}function FK(A,M,Z,q,z,Y){var V=A.pendingLanes;A.pendingLanes=Z,A.suspendedLanes=0,A.pingedLanes=0,A.warmLanes=0,A.expiredLanes&=Z,A.entangledLanes&=Z,A.errorRecoveryDisabledLanes&=Z,A.shellSuspendCounter=0;var{entanglements:Q,expirationTimes:U,hiddenUpdates:B}=A;for(Z=V&~Z;0<Z;){var W=31-SM(Z),J=1<<W;Q[W]=0,U[W]=-1;var I=B[W];if(I!==null)for(B[W]=null,W=0;W<I.length;W++){var K=I[W];K!==null&&(K.lane&=-536870913)}Z&=~J}q!==0&&CG(A,q,0),Y!==0&&z===0&&A.tag!==0&&(A.suspendedLanes|=Y&~(V&~M))}function CG(A,M,Z){A.pendingLanes|=M,A.suspendedLanes&=~M;var q=31-SM(M);A.entangledLanes|=M,A.entanglements[q]=A.entanglements[q]|1073741824|Z&261930}function bG(A,M){var Z=A.entangledLanes|=M;for(A=A.entanglements;Z;){var q=31-SM(Z),z=1<<q;z&M|A[q]&M&&(A[q]|=M),Z&=~z}}function SG(A,M){var Z=M&-M;return Z=(Z&42)!==0?1:GQ(Z),(Z&(A.suspendedLanes|M))!==0?0:Z}function GQ(A){switch(A){case 2:A=1;break;case 8:A=4;break;case 32:A=16;break;case 256:case 512:case 1024:case 2048:case 4096:case 8192:case 16384:case 32768:case 65536:case 131072:case 262144:case 524288:case 1048576:case 2097152:case 4194304:case 8388608:case 16777216:case 33554432:A=128;break;case 268435456:A=134217728;break;default:A=0}return A}function IQ(A){return A&=-A,2<A?8<A?(A&134217727)!==0?32:268435456:8:2}function PG(){var A=zA.p;if(A!==0)return A;return A=window.event,A===void 0?32:AW(A.type)}function t1(A,M){var Z=zA.p;try{return zA.p=A,M()}finally{zA.p=Z}}var FZ=Math.random().toString(36).slice(2),_A="__reactFiber$"+FZ,jM="__reactProps$"+FZ,qz="__reactContainer$"+FZ,j2="__reactEvents$"+FZ,LK="__reactListeners$"+FZ,wK="__reactHandles$"+FZ,e1="__reactResources$"+FZ,LY="__reactMarker$"+FZ;function WQ(A){delete A[_A],delete A[jM],delete A[j2],delete A[LK],delete A[wK]}function bq(A){var M=A[_A];if(M)return M;for(var Z=A.parentNode;Z;){if(M=Z[qz]||Z[_A]){if(Z=M.alternate,M.child!==null||Z!==null&&Z.child!==null)for(A=YG(A);A!==null;){if(Z=A[_A])return Z;A=YG(A)}return M}A=Z,Z=A.parentNode}return null}function zz(A){if(A=A[_A]||A[qz]){var M=A.tag;if(M===5||M===6||M===13||M===31||M===26||M===27||M===3)return A}return null}function pz(A){var M=A.tag;if(M===5||M===26||M===27||M===6)return A.stateNode;throw Error(w(33))}function mq(A){var M=A[e1];return M||(M=A[e1]={hoistableStyles:new Map,hoistableScripts:new Map}),M}function rA(A){A[LY]=!0}var xG=new Set,yG={};function $Z(A,M){oq(A,M),oq(A+"Capture",M)}function oq(A,M){yG[A]=M;for(A=0;A<M.length;A++)xG.add(M[A])}var kK=RegExp("^[:A-Z_a-z\\u00C0-\\u00D6\\u00D8-\\u00F6\\u00F8-\\u02FF\\u0370-\\u037D\\u037F-\\u1FFF\\u200C-\\u200D\\u2070-\\u218F\\u2C00-\\u2FEF\\u3001-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFFD][:A-Z_a-z\\u00C0-\\u00D6\\u00D8-\\u00F6\\u00F8-\\u02FF\\u0370-\\u037D\\u037F-\\u1FFF\\u200C-\\u200D\\u2070-\\u218F\\u2C00-\\u2FEF\\u3001-\\uD7FF\\uF900-\\uFDCF\\uFDF0-\\uFFFD\\-.0-9\\u00B7\\u0300-\\u036F\\u203F-\\u2040]*$"),AB={},MB={};function CK(A){if(N2.call(MB,A))return!0;if(N2.call(AB,A))return!1;if(kK.test(A))return MB[A]=!0;return AB[A]=!0,!1}function D9(A,M,Z){if(CK(M))if(Z===null)A.removeAttribute(M);else{switch(typeof Z){case"undefined":case"function":case"symbol":A.removeAttribute(M);return;case"boolean":var q=M.toLowerCase().slice(0,5);if(q!=="data-"&&q!=="aria-"){A.removeAttribute(M);return}}A.setAttribute(M,""+Z)}}function V9(A,M,Z){if(Z===null)A.removeAttribute(M);else{switch(typeof Z){case"undefined":case"function":case"symbol":case"boolean":A.removeAttribute(M);return}A.setAttribute(M,""+Z)}}function k7(A,M,Z,q){if(q===null)A.removeAttribute(Z);else{switch(typeof q){case"undefined":case"function":case"symbol":case"boolean":A.removeAttribute(Z);return}A.setAttributeNS(M,Z,""+q)}}function dM(A){switch(typeof A){case"bigint":case"boolean":case"number":case"string":case"undefined":return A;case"object":return A;default:return""}}function hG(A){var M=A.type;return(A=A.nodeName)&&A.toLowerCase()==="input"&&(M==="checkbox"||M==="radio")}function bK(A,M,Z){var q=Object.getOwnPropertyDescriptor(A.constructor.prototype,M);if(!A.hasOwnProperty(M)&&typeof q<"u"&&typeof q.get==="function"&&typeof q.set==="function"){var{get:z,set:Y}=q;return Object.defineProperty(A,M,{configurable:!0,get:function(){return z.call(this)},set:function(V){Z=""+V,Y.call(this,V)}}),Object.defineProperty(A,M,{enumerable:q.enumerable}),{getValue:function(){return Z},setValue:function(V){Z=""+V},stopTracking:function(){A._valueTracker=null,delete A[M]}}}}function X2(A){if(!A._valueTracker){var M=hG(A)?"checked":"value";A._valueTracker=bK(A,M,""+A[M])}}function vG(A){if(!A)return!1;var M=A._valueTracker;if(!M)return!0;var Z=M.getValue(),q="";return A&&(q=hG(A)?A.checked?"true":"false":A.value),A=q,A!==Z?(M.setValue(A),!0):!1}function f9(A){if(A=A||(typeof document<"u"?document:void 0),typeof A>"u")return null;try{return A.activeElement||A.body}catch(M){return A.body}}var SK=/[\n"\\]/g;function lM(A){return A.replace(SK,function(M){return"\\"+M.charCodeAt(0).toString(16)+" "})}function O2(A,M,Z,q,z,Y,V,Q){if(A.name="",V!=null&&typeof V!=="function"&&typeof V!=="symbol"&&typeof V!=="boolean"?A.type=V:A.removeAttribute("type"),M!=null)if(V==="number"){if(M===0&&A.value===""||A.value!=M)A.value=""+dM(M)}else A.value!==""+dM(M)&&(A.value=""+dM(M));else V!=="submit"&&V!=="reset"||A.removeAttribute("value");M!=null?E2(A,V,dM(M)):Z!=null?E2(A,V,dM(Z)):q!=null&&A.removeAttribute("value"),z==null&&Y!=null&&(A.defaultChecked=!!Y),z!=null&&(A.checked=z&&typeof z!=="function"&&typeof z!=="symbol"),Q!=null&&typeof Q!=="function"&&typeof Q!=="symbol"&&typeof Q!=="boolean"?A.name=""+dM(Q):A.removeAttribute("name")}function fG(A,M,Z,q,z,Y,V,Q){if(Y!=null&&typeof Y!=="function"&&typeof Y!=="symbol"&&typeof Y!=="boolean"&&(A.type=Y),M!=null||Z!=null){if(!(Y!=="submit"&&Y!=="reset"||M!==void 0&&M!==null)){X2(A);return}Z=Z!=null?""+dM(Z):"",M=M!=null?""+dM(M):Z,Q||M===A.value||(A.value=M),A.defaultValue=M}q=q!=null?q:z,q=typeof q!=="function"&&typeof q!=="symbol"&&!!q,A.checked=Q?A.checked:!!q,A.defaultChecked=!!q,V!=null&&typeof V!=="function"&&typeof V!=="symbol"&&typeof V!=="boolean"&&(A.name=V),X2(A)}function E2(A,M,Z){M==="number"&&f9(A.ownerDocument)===A||A.defaultValue===""+Z||(A.defaultValue=""+Z)}function dq(A,M,Z,q){if(A=A.options,M){M={};for(var z=0;z<Z.length;z++)M["$"+Z[z]]=!0;for(Z=0;Z<A.length;Z++)z=M.hasOwnProperty("$"+A[Z].value),A[Z].selected!==z&&(A[Z].selected=z),z&&q&&(A[Z].defaultSelected=!0)}else{Z=""+dM(Z),M=null;for(z=0;z<A.length;z++){if(A[z].value===Z){A[z].selected=!0,q&&(A[z].defaultSelected=!0);return}M!==null||A[z].disabled||(M=A[z])}M!==null&&(M.selected=!0)}}function gG(A,M,Z){if(M!=null&&(M=""+dM(M),M!==A.value&&(A.value=M),Z==null)){A.defaultValue!==M&&(A.defaultValue=M);return}A.defaultValue=Z!=null?""+dM(Z):""}function uG(A,M,Z,q){if(M==null){if(q!=null){if(Z!=null)throw Error(w(92));if(dz(q)){if(1<q.length)throw Error(w(93));q=q[0]}Z=q}Z==null&&(Z=""),M=Z}Z=dM(M),A.defaultValue=Z,q=A.textContent,q===Z&&q!==""&&q!==null&&(A.value=q),X2(A)}function aq(A,M){if(M){var Z=A.firstChild;if(Z&&Z===A.lastChild&&Z.nodeType===3){Z.nodeValue=M;return}}A.textContent=M}var PK=new Set("animationIterationCount aspectRatio borderImageOutset borderImageSlice borderImageWidth boxFlex boxFlexGroup boxOrdinalGroup columnCount columns flex flexGrow flexPositive flexShrink flexNegative flexOrder gridArea gridRow gridRowEnd gridRowSpan gridRowStart gridColumn gridColumnEnd gridColumnSpan gridColumnStart fontWeight lineClamp lineHeight opacity order orphans scale tabSize widows zIndex zoom fillOpacity floodOpacity stopOpacity strokeDasharray strokeDashoffset strokeMiterlimit strokeOpacity strokeWidth MozAnimationIterationCount MozBoxFlex MozBoxFlexGroup MozLineClamp msAnimationIterationCount msFlex msZoom msFlexGrow msFlexNegative msFlexOrder msFlexPositive msFlexShrink msGridColumn msGridColumnSpan msGridRow msGridRowSpan WebkitAnimationIterationCount WebkitBoxFlex WebKitBoxFlexGroup WebkitBoxOrdinalGroup WebkitColumnCount WebkitColumns WebkitFlex WebkitFlexGrow WebkitFlexPositive WebkitFlexShrink WebkitLineClamp".split(" "));function ZB(A,M,Z){var q=M.indexOf("--")===0;Z==null||typeof Z==="boolean"||Z===""?q?A.setProperty(M,""):M==="float"?A.cssFloat="":A[M]="":q?A.setProperty(M,Z):typeof Z!=="number"||Z===0||PK.has(M)?M==="float"?A.cssFloat=Z:A[M]=(""+Z).trim():A[M]=Z+"px"}function mG(A,M,Z){if(M!=null&&typeof M!=="object")throw Error(w(62));if(A=A.style,Z!=null){for(var q in Z)!Z.hasOwnProperty(q)||M!=null&&M.hasOwnProperty(q)||(q.indexOf("--")===0?A.setProperty(q,""):q==="float"?A.cssFloat="":A[q]="");for(var z in M)q=M[z],M.hasOwnProperty(z)&&Z[z]!==q&&ZB(A,z,q)}else for(var Y in M)M.hasOwnProperty(Y)&&ZB(A,Y,M[Y])}function JQ(A){if(A.indexOf("-")===-1)return!1;switch(A){case"annotation-xml":case"color-profile":case"font-face":case"font-face-src":case"font-face-uri":case"font-face-format":case"font-face-name":case"missing-glyph":return!1;default:return!0}}var xK=new Map([["acceptCharset","accept-charset"],["htmlFor","for"],["httpEquiv","http-equiv"],["crossOrigin","crossorigin"],["accentHeight","accent-height"],["alignmentBaseline","alignment-baseline"],["arabicForm","arabic-form"],["baselineShift","baseline-shift"],["capHeight","cap-height"],["clipPath","clip-path"],["clipRule","clip-rule"],["colorInterpolation","color-interpolation"],["colorInterpolationFilters","color-interpolation-filters"],["colorProfile","color-profile"],["colorRendering","color-rendering"],["dominantBaseline","dominant-baseline"],["enableBackground","enable-background"],["fillOpacity","fill-opacity"],["fillRule","fill-rule"],["floodColor","flood-color"],["floodOpacity","flood-opacity"],["fontFamily","font-family"],["fontSize","font-size"],["fontSizeAdjust","font-size-adjust"],["fontStretch","font-stretch"],["fontStyle","font-style"],["fontVariant","font-variant"],["fontWeight","font-weight"],["glyphName","glyph-name"],["glyphOrientationHorizontal","glyph-orientation-horizontal"],["glyphOrientationVertical","glyph-orientation-vertical"],["horizAdvX","horiz-adv-x"],["horizOriginX","horiz-origin-x"],["imageRendering","image-rendering"],["letterSpacing","letter-spacing"],["lightingColor","lighting-color"],["markerEnd","marker-end"],["markerMid","marker-mid"],["markerStart","marker-start"],["overlinePosition","overline-position"],["overlineThickness","overline-thickness"],["paintOrder","paint-order"],["panose-1","panose-1"],["pointerEvents","pointer-events"],["renderingIntent","rendering-intent"],["shapeRendering","shape-rendering"],["stopColor","stop-color"],["stopOpacity","stop-opacity"],["strikethroughPosition","strikethrough-position"],["strikethroughThickness","strikethrough-thickness"],["strokeDasharray","stroke-dasharray"],["strokeDashoffset","stroke-dashoffset"],["strokeLinecap","stroke-linecap"],["strokeLinejoin","stroke-linejoin"],["strokeMiterlimit","stroke-miterlimit"],["strokeOpacity","stroke-opacity"],["strokeWidth","stroke-width"],["textAnchor","text-anchor"],["textDecoration","text-decoration"],["textRendering","text-rendering"],["transformOrigin","transform-origin"],["underlinePosition","underline-position"],["underlineThickness","underline-thickness"],["unicodeBidi","unicode-bidi"],["unicodeRange","unicode-range"],["unitsPerEm","units-per-em"],["vAlphabetic","v-alphabetic"],["vHanging","v-hanging"],["vIdeographic","v-ideographic"],["vMathematical","v-mathematical"],["vectorEffect","vector-effect"],["vertAdvY","vert-adv-y"],["vertOriginX","vert-origin-x"],["vertOriginY","vert-origin-y"],["wordSpacing","word-spacing"],["writingMode","writing-mode"],["xmlnsXlink","xmlns:xlink"],["xHeight","x-height"]]),yK=/^[\u0000-\u001F ]*j[\r\n\t]*a[\r\n\t]*v[\r\n\t]*a[\r\n\t]*s[\r\n\t]*c[\r\n\t]*r[\r\n\t]*i[\r\n\t]*p[\r\n\t]*t[\r\n\t]*:/i;function N9(A){return yK.test(""+A)?"javascript:throw new Error('React has blocked a javascript: URL as a security precaution.')":A}function v7(){}var R2=null;function TQ(A){return A=A.target||A.srcElement||window,A.correspondingUseElement&&(A=A.correspondingUseElement),A.nodeType===3?A.parentNode:A}var Sq=null,pq=null;function qB(A){var M=zz(A);if(M&&(A=M.stateNode)){var Z=A[jM]||null;A:switch(A=M.stateNode,M.type){case"input":if(O2(A,Z.value,Z.defaultValue,Z.defaultValue,Z.checked,Z.defaultChecked,Z.type,Z.name),M=Z.name,Z.type==="radio"&&M!=null){for(Z=A;Z.parentNode;)Z=Z.parentNode;Z=Z.querySelectorAll('input[name="'+lM(""+M)+'"][type="radio"]');for(M=0;M<Z.length;M++){var q=Z[M];if(q!==A&&q.form===A.form){var z=q[jM]||null;if(!z)throw Error(w(90));O2(q,z.value,z.defaultValue,z.defaultValue,z.checked,z.defaultChecked,z.type,z.name)}}for(M=0;M<Z.length;M++)q=Z[M],q.form===A.form&&vG(q)}break A;case"textarea":gG(A,Z.value,Z.defaultValue);break A;case"select":M=Z.value,M!=null&&dq(A,!!Z.multiple,M,!1)}}}var gV=!1;function dG(A,M,Z){if(gV)return A(M,Z);gV=!0;try{var q=A(M);return q}finally{if(gV=!1,Sq!==null||pq!==null){if(X3(),Sq&&(M=Sq,A=pq,pq=Sq=null,qB(M),A))for(M=0;M<A.length;M++)qB(A[M])}}}function UY(A,M){var Z=A.stateNode;if(Z===null)return null;var q=Z[jM]||null;if(q===null)return null;Z=q[M];A:switch(M){case"onClick":case"onClickCapture":case"onDoubleClick":case"onDoubleClickCapture":case"onMouseDown":case"onMouseDownCapture":case"onMouseMove":case"onMouseMoveCapture":case"onMouseUp":case"onMouseUpCapture":case"onMouseEnter":(q=!q.disabled)||(A=A.type,q=!(A==="button"||A==="input"||A==="select"||A==="textarea")),A=!q;break A;default:A=!1}if(A)return null;if(Z&&typeof Z!=="function")throw Error(w(231,M,typeof Z));return Z}var d7=!(typeof window>"u"||typeof window.document>"u"||typeof window.document.createElement>"u"),H2=!1;if(d7)try{gZ={},Object.defineProperty(gZ,"passive",{get:function(){H2=!0}}),window.addEventListener("test",gZ,gZ),window.removeEventListener("test",gZ,gZ)}catch(A){H2=!1}var gZ,QZ=null,KQ=null,j9=null;function pG(){if(j9)return j9;var A,M=KQ,Z=M.length,q,z="value"in QZ?QZ.value:QZ.textContent,Y=z.length;for(A=0;A<Z&&M[A]===z[A];A++);var V=Z-A;for(q=1;q<=V&&M[Z-q]===z[Y-q];q++);return j9=z.slice(A,1<q?1-q:void 0)}function X9(A){var M=A.keyCode;return"charCode"in A?(A=A.charCode,A===0&&M===13&&(A=13)):A=M,A===10&&(A=13),32<=A||A===13?A:0}function Q9(){return!0}function zB(){return!1}function XM(A){function M(Z,q,z,Y,V){this._reactName=Z,this._targetInst=z,this.type=q,this.nativeEvent=Y,this.target=V,this.currentTarget=null;for(var Q in A)A.hasOwnProperty(Q)&&(Z=A[Q],this[Q]=Z?Z(Y):Y[Q]);return this.isDefaultPrevented=(Y.defaultPrevented!=null?Y.defaultPrevented:Y.returnValue===!1)?Q9:zB,this.isPropagationStopped=zB,this}return XA(M.prototype,{preventDefault:function(){this.defaultPrevented=!0;var Z=this.nativeEvent;Z&&(Z.preventDefault?Z.preventDefault():typeof Z.returnValue!=="unknown"&&(Z.returnValue=!1),this.isDefaultPrevented=Q9)},stopPropagation:function(){var Z=this.nativeEvent;Z&&(Z.stopPropagation?Z.stopPropagation():typeof Z.cancelBubble!=="unknown"&&(Z.cancelBubble=!0),this.isPropagationStopped=Q9)},persist:function(){},isPersistent:Q9}),M}var _Z={eventPhase:0,bubbles:0,cancelable:0,timeStamp:function(A){return A.timeStamp||Date.now()},defaultPrevented:0,isTrusted:0},U3=XM(_Z),wY=XA({},_Z,{view:0,detail:0}),hK=XM(wY),uV,mV,hz,B3=XA({},wY,{screenX:0,screenY:0,clientX:0,clientY:0,pageX:0,pageY:0,ctrlKey:0,shiftKey:0,altKey:0,metaKey:0,getModifierState:DQ,button:0,buttons:0,relatedTarget:function(A){return A.relatedTarget===void 0?A.fromElement===A.srcElement?A.toElement:A.fromElement:A.relatedTarget},movementX:function(A){if("movementX"in A)return A.movementX;return A!==hz&&(hz&&A.type==="mousemove"?(uV=A.screenX-hz.screenX,mV=A.screenY-hz.screenY):mV=uV=0,hz=A),uV},movementY:function(A){return"movementY"in A?A.movementY:mV}}),YB=XM(B3),vK=XA({},B3,{dataTransfer:0}),fK=XM(vK),gK=XA({},wY,{relatedTarget:0}),dV=XM(gK),uK=XA({},_Z,{animationName:0,elapsedTime:0,pseudoElement:0}),mK=XM(uK),dK=XA({},_Z,{clipboardData:function(A){return"clipboardData"in A?A.clipboardData:window.clipboardData}}),pK=XM(dK),cK=XA({},_Z,{data:0}),VB=XM(cK),lK={Esc:"Escape",Spacebar:" ",Left:"ArrowLeft",Up:"ArrowUp",Right:"ArrowRight",Down:"ArrowDown",Del:"Delete",Win:"OS",Menu:"ContextMenu",Apps:"ContextMenu",Scroll:"ScrollLock",MozPrintableKey:"Unidentified"},iK={8:"Backspace",9:"Tab",12:"Clear",13:"Enter",16:"Shift",17:"Control",18:"Alt",19:"Pause",20:"CapsLock",27:"Escape",32:" ",33:"PageUp",34:"PageDown",35:"End",36:"Home",37:"ArrowLeft",38:"ArrowUp",39:"ArrowRight",40:"ArrowDown",45:"Insert",46:"Delete",112:"F1",113:"F2",114:"F3",115:"F4",116:"F5",117:"F6",118:"F7",119:"F8",120:"F9",121:"F10",122:"F11",123:"F12",144:"NumLock",145:"ScrollLock",224:"Meta"},rK={Alt:"altKey",Control:"ctrlKey",Meta:"metaKey",Shift:"shiftKey"};function sK(A){var M=this.nativeEvent;return M.getModifierState?M.getModifierState(A):(A=rK[A])?!!M[A]:!1}function DQ(){return sK}var oK=XA({},wY,{key:function(A){if(A.key){var M=lK[A.key]||A.key;if(M!=="Unidentified")return M}return A.type==="keypress"?(A=X9(A),A===13?"Enter":String.fromCharCode(A)):A.type==="keydown"||A.type==="keyup"?iK[A.keyCode]||"Unidentified":""},code:0,location:0,ctrlKey:0,shiftKey:0,altKey:0,metaKey:0,repeat:0,locale:0,getModifierState:DQ,charCode:function(A){return A.type==="keypress"?X9(A):0},keyCode:function(A){return A.type==="keydown"||A.type==="keyup"?A.keyCode:0},which:function(A){return A.type==="keypress"?X9(A):A.type==="keydown"||A.type==="keyup"?A.keyCode:0}}),aK=XM(oK),nK=XA({},B3,{pointerId:0,width:0,height:0,pressure:0,tangentialPressure:0,tiltX:0,tiltY:0,twist:0,pointerType:0,isPrimary:0}),QB=XM(nK),$K=XA({},wY,{touches:0,targetTouches:0,changedTouches:0,altKey:0,metaKey:0,ctrlKey:0,shiftKey:0,getModifierState:DQ}),_K=XM($K),tK=XA({},_Z,{propertyName:0,elapsedTime:0,pseudoElement:0}),eK=XM(tK),A5=XA({},B3,{deltaX:function(A){return"deltaX"in A?A.deltaX:("wheelDeltaX"in A)?-A.wheelDeltaX:0},deltaY:function(A){return"deltaY"in A?A.deltaY:("wheelDeltaY"in A)?-A.wheelDeltaY:("wheelDelta"in A)?-A.wheelDelta:0},deltaZ:0,deltaMode:0}),M5=XM(A5),Z5=XA({},_Z,{newState:0,oldState:0}),q5=XM(Z5),z5=[9,13,27,32],NQ=d7&&"CompositionEvent"in window,az=null;d7&&"documentMode"in document&&(az=document.documentMode);var Y5=d7&&"TextEvent"in window&&!az,cG=d7&&(!NQ||az&&8<az&&11>=az),UB=String.fromCharCode(32),BB=!1;function lG(A,M){switch(A){case"keyup":return z5.indexOf(M.keyCode)!==-1;case"keydown":return M.keyCode!==229;case"keypress":case"mousedown":case"focusout":return!0;default:return!1}}function iG(A){return A=A.detail,typeof A==="object"&&"data"in A?A.data:null}var Pq=!1;function V5(A,M){switch(A){case"compositionend":return iG(M);case"keypress":if(M.which!==32)return null;return BB=!0,UB;case"textInput":return A=M.data,A===UB&&BB?null:A;default:return null}}function Q5(A,M){if(Pq)return A==="compositionend"||!NQ&&lG(A,M)?(A=pG(),j9=KQ=QZ=null,Pq=!1,A):null;switch(A){case"paste":return null;case"keypress":if(!(M.ctrlKey||M.altKey||M.metaKey)||M.ctrlKey&&M.altKey){if(M.char&&1<M.char.length)return M.char;if(M.which)return String.fromCharCode(M.which)}return null;case"compositionend":return cG&&M.locale!=="ko"?null:M.data;default:return null}}var U5={color:!0,date:!0,datetime:!0,"datetime-local":!0,email:!0,month:!0,number:!0,password:!0,range:!0,search:!0,tel:!0,text:!0,time:!0,url:!0,week:!0};function GB(A){var M=A&&A.nodeName&&A.nodeName.toLowerCase();return M==="input"?!!U5[A.type]:M==="textarea"?!0:!1}function rG(A,M,Z,q){Sq?pq?pq.push(q):pq=[q]:Sq=q,M=A3(M,"onChange"),0<M.length&&(Z=new U3("onChange","change",null,Z,q),A.push({event:Z,listeners:M}))}var nz=null,BY=null;function B5(A){d0(A,0)}function G3(A){var M=pz(A);if(vG(M))return A}function IB(A,M){if(A==="change")return M}var sG=!1;if(d7){if(d7){if(lz="oninput"in document,!lz)O9=document.createElement("div"),O9.setAttribute("oninput","return;"),lz=typeof O9.oninput==="function";cz=lz}else cz=!1;sG=cz&&(!document.documentMode||9<document.documentMode)}var cz,lz,O9;function WB(){nz&&(nz.detachEvent("onpropertychange",oG),BY=nz=null)}function oG(A){if(A.propertyName==="value"&&G3(BY)){var M=[];rG(M,BY,A,TQ(A)),dG(B5,M)}}function G5(A,M,Z){A==="focusin"?(WB(),nz=M,BY=Z,nz.attachEvent("onpropertychange",oG)):A==="focusout"&&WB()}function I5(A){if(A==="selectionchange"||A==="keyup"||A==="keydown")return G3(BY)}function W5(A,M){if(A==="click")return G3(M)}function J5(A,M){if(A==="input"||A==="change")return G3(M)}function T5(A,M){return A===M&&(A!==0||1/A===1/M)||A!==A&&M!==M}var xM=typeof Object.is==="function"?Object.is:T5;function GY(A,M){if(xM(A,M))return!0;if(typeof A!=="object"||A===null||typeof M!=="object"||M===null)return!1;var Z=Object.keys(A),q=Object.keys(M);if(Z.length!==q.length)return!1;for(q=0;q<Z.length;q++){var z=Z[q];if(!N2.call(M,z)||!xM(A[z],M[z]))return!1}return!0}function JB(A){for(;A&&A.firstChild;)A=A.firstChild;return A}function TB(A,M){var Z=JB(A);A=0;for(var q;Z;){if(Z.nodeType===3){if(q=A+Z.textContent.length,A<=M&&q>=M)return{node:Z,offset:M-A};A=q}A:{for(;Z;){if(Z.nextSibling){Z=Z.nextSibling;break A}Z=Z.parentNode}Z=void 0}Z=JB(Z)}}function aG(A,M){return A&&M?A===M?!0:A&&A.nodeType===3?!1:M&&M.nodeType===3?aG(A,M.parentNode):("contains"in A)?A.contains(M):A.compareDocumentPosition?!!(A.compareDocumentPosition(M)&16):!1:!1}function nG(A){A=A!=null&&A.ownerDocument!=null&&A.ownerDocument.defaultView!=null?A.ownerDocument.defaultView:window;for(var M=f9(A.document);M instanceof A.HTMLIFrameElement;){try{var Z=typeof M.contentWindow.location.href==="string"}catch(q){Z=!1}if(Z)A=M.contentWindow;else break;M=f9(A.document)}return M}function jQ(A){var M=A&&A.nodeName&&A.nodeName.toLowerCase();return M&&(M==="input"&&(A.type==="text"||A.type==="search"||A.type==="tel"||A.type==="url"||A.type==="password")||M==="textarea"||A.contentEditable==="true")}var K5=d7&&"documentMode"in document&&11>=document.documentMode,xq=null,F2=null,$z=null,L2=!1;function KB(A,M,Z){var q=Z.window===Z?Z.document:Z.nodeType===9?Z:Z.ownerDocument;L2||xq==null||xq!==f9(q)||(q=xq,("selectionStart"in q)&&jQ(q)?q={start:q.selectionStart,end:q.selectionEnd}:(q=(q.ownerDocument&&q.ownerDocument.defaultView||window).getSelection(),q={anchorNode:q.anchorNode,anchorOffset:q.anchorOffset,focusNode:q.focusNode,focusOffset:q.focusOffset}),$z&&GY($z,q)||($z=q,q=A3(F2,"onSelect"),0<q.length&&(M=new U3("onSelect","select",null,M,Z),A.push({event:M,listeners:q}),M.target=xq)))}function hZ(A,M){var Z={};return Z[A.toLowerCase()]=M.toLowerCase(),Z["Webkit"+A]="webkit"+M,Z["Moz"+A]="moz"+M,Z}var yq={animationend:hZ("Animation","AnimationEnd"),animationiteration:hZ("Animation","AnimationIteration"),animationstart:hZ("Animation","AnimationStart"),transitionrun:hZ("Transition","TransitionRun"),transitionstart:hZ("Transition","TransitionStart"),transitioncancel:hZ("Transition","TransitionCancel"),transitionend:hZ("Transition","TransitionEnd")},pV={},$G={};d7&&($G=document.createElement("div").style,("AnimationEvent"in window)||(delete yq.animationend.animation,delete yq.animationiteration.animation,delete yq.animationstart.animation),("TransitionEvent"in window)||delete yq.transitionend.transition);function tZ(A){if(pV[A])return pV[A];if(!yq[A])return A;var M=yq[A],Z;for(Z in M)if(M.hasOwnProperty(Z)&&Z in $G)return pV[A]=M[Z];return A}var _G=tZ("animationend"),tG=tZ("animationiteration"),eG=tZ("animationstart"),D5=tZ("transitionrun"),N5=tZ("transitionstart"),j5=tZ("transitioncancel"),AI=tZ("transitionend"),MI=new Map,w2="abort auxClick beforeToggle cancel canPlay canPlayThrough click close contextMenu copy cut drag dragEnd dragEnter dragExit dragLeave dragOver dragStart drop durationChange emptied encrypted ended error gotPointerCapture input invalid keyDown keyPress keyUp load loadedData loadedMetadata loadStart lostPointerCapture mouseDown mouseMove mouseOut mouseOver mouseUp paste pause play playing pointerCancel pointerDown pointerMove pointerOut pointerOver pointerUp progress rateChange reset resize seeked seeking stalled submit suspend timeUpdate touchCancel touchEnd touchStart volumeChange scroll toggle touchMove waiting wheel".split(" ");w2.push("scrollEnd");function Z7(A,M){MI.set(A,M),$Z(M,[A])}var g9=typeof reportError==="function"?reportError:function(A){if(typeof window==="object"&&typeof window.ErrorEvent==="function"){var M=new window.ErrorEvent("error",{bubbles:!0,cancelable:!0,message:typeof A==="object"&&A!==null&&typeof A.message==="string"?String(A.message):String(A),error:A});if(!window.dispatchEvent(M))return}else if(typeof process==="object"&&typeof process.emit==="function"){process.emit("uncaughtException",A);return}console.error(A)},mM=[],hq=0,XQ=0;function I3(){for(var A=hq,M=XQ=hq=0;M<A;){var Z=mM[M];mM[M++]=null;var q=mM[M];mM[M++]=null;var z=mM[M];mM[M++]=null;var Y=mM[M];if(mM[M++]=null,q!==null&&z!==null){var V=q.pending;V===null?z.next=z:(z.next=V.next,V.next=z),q.pending=z}Y!==0&&ZI(Z,z,Y)}}function W3(A,M,Z,q){mM[hq++]=A,mM[hq++]=M,mM[hq++]=Z,mM[hq++]=q,XQ|=q,A.lanes|=q,A=A.alternate,A!==null&&(A.lanes|=q)}function OQ(A,M,Z,q){return W3(A,M,Z,q),u9(A)}function eZ(A,M){return W3(A,null,null,M),u9(A)}function ZI(A,M,Z){A.lanes|=Z;var q=A.alternate;q!==null&&(q.lanes|=Z);for(var z=!1,Y=A.return;Y!==null;)Y.childLanes|=Z,q=Y.alternate,q!==null&&(q.childLanes|=Z),Y.tag===22&&(A=Y.stateNode,A===null||A._visibility&1||(z=!0)),A=Y,Y=Y.return;return A.tag===3?(Y=A.stateNode,z&&M!==null&&(z=31-SM(Z),A=Y.hiddenUpdates,q=A[z],q===null?A[z]=[M]:q.push(M),M.lane=Z|536870912),Y):null}function u9(A){if(50<YY)throw YY=0,o2=null,Error(w(185));for(var M=A.return;M!==null;)A=M,M=A.return;return A.tag===3?A.stateNode:null}var vq={};function X5(A,M,Z,q){this.tag=A,this.key=Z,this.sibling=this.child=this.return=this.stateNode=this.type=this.elementType=null,this.index=0,this.refCleanup=this.ref=null,this.pendingProps=M,this.dependencies=this.memoizedState=this.updateQueue=this.memoizedProps=null,this.mode=q,this.subtreeFlags=this.flags=0,this.deletions=null,this.childLanes=this.lanes=0,this.alternate=null}function wM(A,M,Z,q){return new X5(A,M,Z,q)}function EQ(A){return A=A.prototype,!(!A||!A.isReactComponent)}function g7(A,M){var Z=A.alternate;return Z===null?(Z=wM(A.tag,M,A.key,A.mode),Z.elementType=A.elementType,Z.type=A.type,Z.stateNode=A.stateNode,Z.alternate=A,A.alternate=Z):(Z.pendingProps=M,Z.type=A.type,Z.flags=0,Z.subtreeFlags=0,Z.deletions=null),Z.flags=A.flags&65011712,Z.childLanes=A.childLanes,Z.lanes=A.lanes,Z.child=A.child,Z.memoizedProps=A.memoizedProps,Z.memoizedState=A.memoizedState,Z.updateQueue=A.updateQueue,M=A.dependencies,Z.dependencies=M===null?null:{lanes:M.lanes,firstContext:M.firstContext},Z.sibling=A.sibling,Z.index=A.index,Z.ref=A.ref,Z.refCleanup=A.refCleanup,Z}function qI(A,M){A.flags&=65011714;var Z=A.alternate;return Z===null?(A.childLanes=0,A.lanes=M,A.child=null,A.subtreeFlags=0,A.memoizedProps=null,A.memoizedState=null,A.updateQueue=null,A.dependencies=null,A.stateNode=null):(A.childLanes=Z.childLanes,A.lanes=Z.lanes,A.child=Z.child,A.subtreeFlags=0,A.deletions=null,A.memoizedProps=Z.memoizedProps,A.memoizedState=Z.memoizedState,A.updateQueue=Z.updateQueue,A.type=Z.type,M=Z.dependencies,A.dependencies=M===null?null:{lanes:M.lanes,firstContext:M.firstContext}),A}function E9(A,M,Z,q,z,Y){var V=0;if(q=A,typeof A==="function")EQ(A)&&(V=1);else if(typeof A==="string")V=RD(A,Z,j7.current)?26:A==="html"||A==="head"||A==="body"?27:5;else A:switch(A){case J2:return A=wM(31,Z,M,z),A.elementType=J2,A.lanes=Y,A;case kq:return pZ(Z.children,z,Y,M);case RG:V=8,z|=24;break;case G2:return A=wM(12,Z,M,z|2),A.elementType=G2,A.lanes=Y,A;case I2:return A=wM(13,Z,M,z),A.elementType=I2,A.lanes=Y,A;case W2:return A=wM(19,Z,M,z),A.elementType=W2,A.lanes=Y,A;default:if(typeof A==="object"&&A!==null)switch(A.$$typeof){case h7:V=10;break A;case HG:V=9;break A;case QQ:V=11;break A;case UQ:V=14;break A;case AZ:V=16,q=null;break A}V=29,Z=Error(w(130,A===null?"null":typeof A,"")),q=null}return M=wM(V,Z,M,z),M.elementType=A,M.type=q,M.lanes=Y,M}function pZ(A,M,Z,q){return A=wM(7,A,q,M),A.lanes=Z,A}function cV(A,M,Z){return A=wM(6,A,null,M),A.lanes=Z,A}function zI(A){var M=wM(18,null,null,0);return M.stateNode=A,M}function lV(A,M,Z){return M=wM(4,A.children!==null?A.children:[],A.key,M),M.lanes=Z,M.stateNode={containerInfo:A.containerInfo,pendingChildren:null,implementation:A.implementation},M}var DB=new WeakMap;function iM(A,M){if(typeof A==="object"&&A!==null){var Z=DB.get(A);if(Z!==void 0)return Z;return M={value:A,source:M,stack:_1(M)},DB.set(A,M),M}return{value:A,source:M,stack:_1(M)}}var fq=[],gq=0,m9=null,IY=0,pM=[],cM=0,OZ=null,K7=1,D7="";function x7(A,M){fq[gq++]=IY,fq[gq++]=m9,m9=A,IY=M}function YI(A,M,Z){pM[cM++]=K7,pM[cM++]=D7,pM[cM++]=OZ,OZ=A;var q=K7;A=D7;var z=32-SM(q)-1;q&=~(1<<z),Z+=1;var Y=32-SM(M)+z;if(30<Y){var V=z-z%5;Y=(q&(1<<V)-1).toString(32),q>>=V,z-=V,K7=1<<32-SM(M)+z|Z<<z|q,D7=Y+A}else K7=1<<Y|Z<<z|q,D7=A}function RQ(A){A.return!==null&&(x7(A,1),YI(A,1,0))}function HQ(A){for(;A===m9;)m9=fq[--gq],fq[gq]=null,IY=fq[--gq],fq[gq]=null;for(;A===OZ;)OZ=pM[--cM],pM[cM]=null,D7=pM[--cM],pM[cM]=null,K7=pM[--cM],pM[cM]=null}function VI(A,M){pM[cM++]=K7,pM[cM++]=D7,pM[cM++]=OZ,K7=M.id,D7=M.overflow,OZ=A}var tA=null,jA=null,e=!1,WZ=null,rM=!1,k2=Error(w(519));function EZ(A){var M=Error(w(418,1<arguments.length&&arguments[1]!==void 0&&arguments[1]?"text":"HTML",""));throw WY(iM(M,A)),k2}function NB(A){var{stateNode:M,type:Z,memoizedProps:q}=A;switch(M[_A]=A,M[jM]=q,Z){case"dialog":$("cancel",M),$("close",M);break;case"iframe":case"object":case"embed":$("load",M);break;case"video":case"audio":for(Z=0;Z<DY.length;Z++)$(DY[Z],M);break;case"source":$("error",M);break;case"img":case"image":case"link":$("error",M),$("load",M);break;case"details":$("toggle",M);break;case"input":$("invalid",M),fG(M,q.value,q.defaultValue,q.checked,q.defaultChecked,q.type,q.name,!0);break;case"select":$("invalid",M);break;case"textarea":$("invalid",M),uG(M,q.value,q.defaultValue,q.children)}Z=q.children,typeof Z!=="string"&&typeof Z!=="number"&&typeof Z!=="bigint"||M.textContent===""+Z||q.suppressHydrationWarning===!0||c0(M.textContent,Z)?(q.popover!=null&&($("beforetoggle",M),$("toggle",M)),q.onScroll!=null&&$("scroll",M),q.onScrollEnd!=null&&$("scrollend",M),q.onClick!=null&&(M.onclick=v7),M=!0):M=!1,M||EZ(A,!0)}function jB(A){for(tA=A.return;tA;)switch(tA.tag){case 5:case 31:case 13:rM=!1;return;case 27:case 3:rM=!0;return;default:tA=tA.return}}function Rq(A){if(A!==tA)return!1;if(!e)return jB(A),e=!0,!1;var M=A.tag,Z;if(Z=M!==3&&M!==27){if(Z=M===5)Z=A.type,Z=!(Z!=="form"&&Z!=="button")||AQ(A.type,A.memoizedProps);Z=!Z}if(Z&&jA&&EZ(A),jB(A),M===13){if(A=A.memoizedState,A=A!==null?A.dehydrated:null,!A)throw Error(w(317));jA=zG(A)}else if(M===31){if(A=A.memoizedState,A=A!==null?A.dehydrated:null,!A)throw Error(w(317));jA=zG(A)}else M===27?(M=jA,LZ(A.type)?(A=zQ,zQ=null,jA=A):jA=M):jA=tA?oM(A.stateNode.nextSibling):null;return!0}function rZ(){jA=tA=null,e=!1}function iV(){var A=WZ;return A!==null&&(DM===null?DM=A:DM.push.apply(DM,A),WZ=null),A}function WY(A){WZ===null?WZ=[A]:WZ.push(A)}var C2=X7(null),Aq=null,f7=null;function ZZ(A,M,Z){TA(C2,M._currentValue),M._currentValue=Z}function u7(A){A._currentValue=C2.current,sA(C2)}function b2(A,M,Z){for(;A!==null;){var q=A.alternate;if((A.childLanes&M)!==M?(A.childLanes|=M,q!==null&&(q.childLanes|=M)):q!==null&&(q.childLanes&M)!==M&&(q.childLanes|=M),A===Z)break;A=A.return}}function S2(A,M,Z,q){var z=A.child;z!==null&&(z.return=A);for(;z!==null;){var Y=z.dependencies;if(Y!==null){var V=z.child;Y=Y.firstContext;A:for(;Y!==null;){var Q=Y;Y=z;for(var U=0;U<M.length;U++)if(Q.context===M[U]){Y.lanes|=Z,Q=Y.alternate,Q!==null&&(Q.lanes|=Z),b2(Y.return,Z,A),q||(V=null);break A}Y=Q.next}}else if(z.tag===18){if(V=z.return,V===null)throw Error(w(341));V.lanes|=Z,Y=V.alternate,Y!==null&&(Y.lanes|=Z),b2(V,Z,A),V=null}else V=z.child;if(V!==null)V.return=z;else for(V=z;V!==null;){if(V===A){V=null;break}if(z=V.sibling,z!==null){z.return=V.return,V=z;break}V=V.return}z=V}}function Yz(A,M,Z,q){A=null;for(var z=M,Y=!1;z!==null;){if(!Y){if((z.flags&524288)!==0)Y=!0;else if((z.flags&262144)!==0)break}if(z.tag===10){var V=z.alternate;if(V===null)throw Error(w(387));if(V=V.memoizedProps,V!==null){var Q=z.type;xM(z.pendingProps.value,V.value)||(A!==null?A.push(Q):A=[Q])}}else if(z===x9.current){if(V=z.alternate,V===null)throw Error(w(387));V.memoizedState.memoizedState!==z.memoizedState.memoizedState&&(A!==null?A.push(jY):A=[jY])}z=z.return}A!==null&&S2(M,A,Z,q),M.flags|=262144}function d9(A){for(A=A.firstContext;A!==null;){if(!xM(A.context._currentValue,A.memoizedValue))return!0;A=A.next}return!1}function sZ(A){Aq=A,f7=null,A=A.dependencies,A!==null&&(A.firstContext=null)}function eA(A){return QI(Aq,A)}function U9(A,M){return Aq===null&&sZ(A),QI(A,M)}function QI(A,M){var Z=M._currentValue;if(M={context:M,memoizedValue:Z,next:null},f7===null){if(A===null)throw Error(w(308));f7=M,A.dependencies={lanes:0,firstContext:M},A.flags|=524288}else f7=f7.next=M;return Z}var O5=typeof AbortController<"u"?AbortController:function(){var A=[],M=this.signal={aborted:!1,addEventListener:function(Z,q){A.push(q)}};this.abort=function(){M.aborted=!0,A.forEach(function(Z){return Z()})}},E5=cA.unstable_scheduleCallback,R5=cA.unstable_NormalPriority,fA={$$typeof:h7,Consumer:null,Provider:null,_currentValue:null,_currentValue2:null,_threadCount:0};function FQ(){return{controller:new O5,data:new Map,refCount:0}}function kY(A){A.refCount--,A.refCount===0&&E5(R5,function(){A.controller.abort()})}var _z=null,P2=0,nq=0,cq=null;function H5(A,M){if(_z===null){var Z=_z=[];P2=0,nq=nQ(),cq={status:"pending",value:void 0,then:function(q){Z.push(q)}}}return P2++,M.then(XB,XB),M}function XB(){if(--P2===0&&_z!==null){cq!==null&&(cq.status="fulfilled");var A=_z;_z=null,nq=0,cq=null;for(var M=0;M<A.length;M++)(0,A[M])()}}function F5(A,M){var Z=[],q={status:"pending",value:null,reason:null,then:function(z){Z.push(z)}};return A.then(function(){q.status="fulfilled",q.value=M;for(var z=0;z<Z.length;z++)(0,Z[z])(M)},function(z){q.status="rejected",q.reason=z;for(z=0;z<Z.length;z++)(0,Z[z])(void 0)}),q}var OB=f.S;f.S=function(A,M){E0=CM(),typeof M==="object"&&M!==null&&typeof M.then==="function"&&H5(A,M),OB!==null&&OB(A,M)};var cZ=X7(null);function LQ(){var A=cZ.current;return A!==null?A:JA.pooledCache}function R9(A,M){M===null?TA(cZ,cZ.current):TA(cZ,M.pool)}function UI(){var A=LQ();return A===null?null:{parent:fA._currentValue,pool:A}}var Vz=Error(w(460)),wQ=Error(w(474)),J3=Error(w(542)),p9={then:function(){}};function EB(A){return A=A.status,A==="fulfilled"||A==="rejected"}function BI(A,M,Z){switch(Z=A[Z],Z===void 0?A.push(M):Z!==M&&(M.then(v7,v7),M=Z),M.status){case"fulfilled":return M.value;case"rejected":throw A=M.reason,HB(A),A;default:if(typeof M.status==="string")M.then(v7,v7);else{if(A=JA,A!==null&&100<A.shellSuspendCounter)throw Error(w(482));A=M,A.status="pending",A.then(function(q){if(M.status==="pending"){var z=M;z.status="fulfilled",z.value=q}},function(q){if(M.status==="pending"){var z=M;z.status="rejected",z.reason=q}})}switch(M.status){case"fulfilled":return M.value;case"rejected":throw A=M.reason,HB(A),A}throw lZ=M,Vz}}function uZ(A){try{var M=A._init;return M(A._payload)}catch(Z){if(Z!==null&&typeof Z==="object"&&typeof Z.then==="function")throw lZ=Z,Vz;throw Z}}var lZ=null;function RB(){if(lZ===null)throw Error(w(459));var A=lZ;return lZ=null,A}function HB(A){if(A===Vz||A===J3)throw Error(w(483))}var lq=null,JY=0;function B9(A){var M=JY;return JY+=1,lq===null&&(lq=[]),BI(lq,A,M)}function vz(A,M){M=M.props.ref,A.ref=M!==void 0?M:null}function G9(A,M){if(M.$$typeof===GK)throw Error(w(525));throw A=Object.prototype.toString.call(M),Error(w(31,A==="[object Object]"?"object with keys {"+Object.keys(M).join(", ")+"}":A))}function GI(A){function M(T,G){if(A){var D=T.deletions;D===null?(T.deletions=[G],T.flags|=16):D.push(G)}}function Z(T,G){if(!A)return null;for(;G!==null;)M(T,G),G=G.sibling;return null}function q(T){for(var G=new Map;T!==null;)T.key!==null?G.set(T.key,T):G.set(T.index,T),T=T.sibling;return G}function z(T,G){return T=g7(T,G),T.index=0,T.sibling=null,T}function Y(T,G,D){if(T.index=D,!A)return T.flags|=1048576,G;if(D=T.alternate,D!==null)return D=D.index,D<G?(T.flags|=67108866,G):D;return T.flags|=67108866,G}function V(T){return A&&T.alternate===null&&(T.flags|=67108866),T}function Q(T,G,D,X){if(G===null||G.tag!==6)return G=cV(D,T.mode,X),G.return=T,G;return G=z(G,D),G.return=T,G}function U(T,G,D,X){var H=D.type;if(H===kq)return W(T,G,D.props.children,X,D.key);if(G!==null&&(G.elementType===H||typeof H==="object"&&H!==null&&H.$$typeof===AZ&&uZ(H)===G.type))return G=z(G,D.props),vz(G,D),G.return=T,G;return G=E9(D.type,D.key,D.props,null,T.mode,X),vz(G,D),G.return=T,G}function B(T,G,D,X){if(G===null||G.tag!==4||G.stateNode.containerInfo!==D.containerInfo||G.stateNode.implementation!==D.implementation)return G=lV(D,T.mode,X),G.return=T,G;return G=z(G,D.children||[]),G.return=T,G}function W(T,G,D,X,H){if(G===null||G.tag!==7)return G=pZ(D,T.mode,X,H),G.return=T,G;return G=z(G,D),G.return=T,G}function J(T,G,D){if(typeof G==="string"&&G!==""||typeof G==="number"||typeof G==="bigint")return G=cV(""+G,T.mode,D),G.return=T,G;if(typeof G==="object"&&G!==null){switch(G.$$typeof){case Z9:return D=E9(G.type,G.key,G.props,null,T.mode,D),vz(D,G),D.return=T,D;case mz:return G=lV(G,T.mode,D),G.return=T,G;case AZ:return G=uZ(G),J(T,G,D)}if(dz(G)||yz(G))return G=pZ(G,T.mode,D,null),G.return=T,G;if(typeof G.then==="function")return J(T,B9(G),D);if(G.$$typeof===h7)return J(T,U9(T,G),D);G9(T,G)}return null}function I(T,G,D,X){var H=G!==null?G.key:null;if(typeof D==="string"&&D!==""||typeof D==="number"||typeof D==="bigint")return H!==null?null:Q(T,G,""+D,X);if(typeof D==="object"&&D!==null){switch(D.$$typeof){case Z9:return D.key===H?U(T,G,D,X):null;case mz:return D.key===H?B(T,G,D,X):null;case AZ:return D=uZ(D),I(T,G,D,X)}if(dz(D)||yz(D))return H!==null?null:W(T,G,D,X,null);if(typeof D.then==="function")return I(T,G,B9(D),X);if(D.$$typeof===h7)return I(T,G,U9(T,D),X);G9(T,D)}return null}function K(T,G,D,X,H){if(typeof X==="string"&&X!==""||typeof X==="number"||typeof X==="bigint")return T=T.get(D)||null,Q(G,T,""+X,H);if(typeof X==="object"&&X!==null){switch(X.$$typeof){case Z9:return T=T.get(X.key===null?D:X.key)||null,U(G,T,X,H);case mz:return T=T.get(X.key===null?D:X.key)||null,B(G,T,X,H);case AZ:return X=uZ(X),K(T,G,D,X,H)}if(dz(X)||yz(X))return T=T.get(D)||null,W(G,T,X,H,null);if(typeof X.then==="function")return K(T,G,D,B9(X),H);if(X.$$typeof===h7)return K(T,G,D,U9(G,X),H);G9(G,X)}return null}function N(T,G,D,X){for(var H=null,L=null,F=G,R=G=0,k=null;F!==null&&R<D.length;R++){F.index>R?(k=F,F=null):k=F.sibling;var b=I(T,F,D[R],X);if(b===null){F===null&&(F=k);break}A&&F&&b.alternate===null&&M(T,F),G=Y(b,G,R),L===null?H=b:L.sibling=b,L=b,F=k}if(R===D.length)return Z(T,F),e&&x7(T,R),H;if(F===null){for(;R<D.length;R++)F=J(T,D[R],X),F!==null&&(G=Y(F,G,R),L===null?H=F:L.sibling=F,L=F);return e&&x7(T,R),H}for(F=q(F);R<D.length;R++)k=K(F,T,R,D[R],X),k!==null&&(A&&k.alternate!==null&&F.delete(k.key===null?R:k.key),G=Y(k,G,R),L===null?H=k:L.sibling=k,L=k);return A&&F.forEach(function(u){return M(T,u)}),e&&x7(T,R),H}function O(T,G,D,X){if(D==null)throw Error(w(151));for(var H=null,L=null,F=G,R=G=0,k=null,b=D.next();F!==null&&!b.done;R++,b=D.next()){F.index>R?(k=F,F=null):k=F.sibling;var u=I(T,F,b.value,X);if(u===null){F===null&&(F=k);break}A&&F&&u.alternate===null&&M(T,F),G=Y(u,G,R),L===null?H=u:L.sibling=u,L=u,F=k}if(b.done)return Z(T,F),e&&x7(T,R),H;if(F===null){for(;!b.done;R++,b=D.next())b=J(T,b.value,X),b!==null&&(G=Y(b,G,R),L===null?H=b:L.sibling=b,L=b);return e&&x7(T,R),H}for(F=q(F);!b.done;R++,b=D.next())b=K(F,T,R,b.value,X),b!==null&&(A&&b.alternate!==null&&F.delete(b.key===null?R:b.key),G=Y(b,G,R),L===null?H=b:L.sibling=b,L=b);return A&&F.forEach(function(h){return M(T,h)}),e&&x7(T,R),H}function j(T,G,D,X){if(typeof D==="object"&&D!==null&&D.type===kq&&D.key===null&&(D=D.props.children),typeof D==="object"&&D!==null){switch(D.$$typeof){case Z9:A:{for(var H=D.key;G!==null;){if(G.key===H){if(H=D.type,H===kq){if(G.tag===7){Z(T,G.sibling),X=z(G,D.props.children),X.return=T,T=X;break A}}else if(G.elementType===H||typeof H==="object"&&H!==null&&H.$$typeof===AZ&&uZ(H)===G.type){Z(T,G.sibling),X=z(G,D.props),vz(X,D),X.return=T,T=X;break A}Z(T,G);break}else M(T,G);G=G.sibling}D.type===kq?(X=pZ(D.props.children,T.mode,X,D.key),X.return=T,T=X):(X=E9(D.type,D.key,D.props,null,T.mode,X),vz(X,D),X.return=T,T=X)}return V(T);case mz:A:{for(H=D.key;G!==null;){if(G.key===H)if(G.tag===4&&G.stateNode.containerInfo===D.containerInfo&&G.stateNode.implementation===D.implementation){Z(T,G.sibling),X=z(G,D.children||[]),X.return=T,T=X;break A}else{Z(T,G);break}else M(T,G);G=G.sibling}X=lV(D,T.mode,X),X.return=T,T=X}return V(T);case AZ:return D=uZ(D),j(T,G,D,X)}if(dz(D))return N(T,G,D,X);if(yz(D)){if(H=yz(D),typeof H!=="function")throw Error(w(150));return D=H.call(D),O(T,G,D,X)}if(typeof D.then==="function")return j(T,G,B9(D),X);if(D.$$typeof===h7)return j(T,G,U9(T,D),X);G9(T,D)}return typeof D==="string"&&D!==""||typeof D==="number"||typeof D==="bigint"?(D=""+D,G!==null&&G.tag===6?(Z(T,G.sibling),X=z(G,D),X.return=T,T=X):(Z(T,G),X=cV(D,T.mode,X),X.return=T,T=X),V(T)):Z(T,G)}return function(T,G,D,X){try{JY=0;var H=j(T,G,D,X);return lq=null,H}catch(F){if(F===Vz||F===J3)throw F;var L=wM(29,F,null,T.mode);return L.lanes=X,L.return=T,L}finally{}}}var oZ=GI(!0),II=GI(!1),MZ=!1;function kQ(A){A.updateQueue={baseState:A.memoizedState,firstBaseUpdate:null,lastBaseUpdate:null,shared:{pending:null,lanes:0,hiddenCallbacks:null},callbacks:null}}function x2(A,M){A=A.updateQueue,M.updateQueue===A&&(M.updateQueue={baseState:A.baseState,firstBaseUpdate:A.firstBaseUpdate,lastBaseUpdate:A.lastBaseUpdate,shared:A.shared,callbacks:null})}function JZ(A){return{lane:A,tag:0,payload:null,callback:null,next:null}}function TZ(A,M,Z){var q=A.updateQueue;if(q===null)return null;if(q=q.shared,(qA&2)!==0){var z=q.pending;return z===null?M.next=M:(M.next=z.next,z.next=M),q.pending=M,M=u9(A),ZI(A,null,Z),M}return W3(A,q,M,Z),u9(A)}function tz(A,M,Z){if(M=M.updateQueue,M!==null&&(M=M.shared,(Z&4194048)!==0)){var q=M.lanes;q&=A.pendingLanes,Z|=q,M.lanes=Z,bG(A,Z)}}function rV(A,M){var{updateQueue:Z,alternate:q}=A;if(q!==null&&(q=q.updateQueue,Z===q)){var z=null,Y=null;if(Z=Z.firstBaseUpdate,Z!==null){do{var V={lane:Z.lane,tag:Z.tag,payload:Z.payload,callback:null,next:null};Y===null?z=Y=V:Y=Y.next=V,Z=Z.next}while(Z!==null);Y===null?z=Y=M:Y=Y.next=M}else z=Y=M;Z={baseState:q.baseState,firstBaseUpdate:z,lastBaseUpdate:Y,shared:q.shared,callbacks:q.callbacks},A.updateQueue=Z;return}A=Z.lastBaseUpdate,A===null?Z.firstBaseUpdate=M:A.next=M,Z.lastBaseUpdate=M}var y2=!1;function ez(){if(y2){var A=cq;if(A!==null)throw A}}function AY(A,M,Z,q){y2=!1;var z=A.updateQueue;MZ=!1;var{firstBaseUpdate:Y,lastBaseUpdate:V}=z,Q=z.shared.pending;if(Q!==null){z.shared.pending=null;var U=Q,B=U.next;U.next=null,V===null?Y=B:V.next=B,V=U;var W=A.alternate;W!==null&&(W=W.updateQueue,Q=W.lastBaseUpdate,Q!==V&&(Q===null?W.firstBaseUpdate=B:Q.next=B,W.lastBaseUpdate=U))}if(Y!==null){var J=z.baseState;V=0,W=B=U=null,Q=Y;do{var I=Q.lane&-536870913,K=I!==Q.lane;if(K?(t&I)===I:(q&I)===I){I!==0&&I===nq&&(y2=!0),W!==null&&(W=W.next={lane:0,tag:Q.tag,payload:Q.payload,callback:null,next:null});A:{var N=A,O=Q;I=M;var j=Z;switch(O.tag){case 1:if(N=O.payload,typeof N==="function"){J=N.call(j,J,I);break A}J=N;break A;case 3:N.flags=N.flags&-65537|128;case 0:if(N=O.payload,I=typeof N==="function"?N.call(j,J,I):N,I===null||I===void 0)break A;J=XA({},J,I);break A;case 2:MZ=!0}}I=Q.callback,I!==null&&(A.flags|=64,K&&(A.flags|=8192),K=z.callbacks,K===null?z.callbacks=[I]:K.push(I))}else K={lane:I,tag:Q.tag,payload:Q.payload,callback:Q.callback,next:null},W===null?(B=W=K,U=J):W=W.next=K,V|=I;if(Q=Q.next,Q===null)if(Q=z.shared.pending,Q===null)break;else K=Q,Q=K.next,K.next=null,z.lastBaseUpdate=K,z.shared.pending=null}while(1);W===null&&(U=J),z.baseState=U,z.firstBaseUpdate=B,z.lastBaseUpdate=W,Y===null&&(z.shared.lanes=0),HZ|=V,A.lanes=V,A.memoizedState=J}}function WI(A,M){if(typeof A!=="function")throw Error(w(191,A));A.call(M)}function JI(A,M){var Z=A.callbacks;if(Z!==null)for(A.callbacks=null,A=0;A<Z.length;A++)WI(Z[A],M)}var $q=X7(null),c9=X7(0);function FB(A,M){A=i7,TA(c9,A),TA($q,M),i7=A|M.baseLanes}function h2(){TA(c9,i7),TA($q,$q.current)}function CQ(){i7=c9.current,sA($q),sA(c9)}var yM=X7(null),sM=null;function qZ(A){var M=A.alternate;TA(SA,SA.current&1),TA(yM,A),sM===null&&(M===null||$q.current!==null?sM=A:M.memoizedState!==null&&(sM=A))}function v2(A){TA(SA,SA.current),TA(yM,A),sM===null&&(sM=A)}function TI(A){A.tag===22?(TA(SA,SA.current),TA(yM,A),sM===null&&(sM=A)):zZ(A)}function zZ(){TA(SA,SA.current),TA(yM,yM.current)}function LM(A){sA(yM),sM===A&&(sM=null),sA(SA)}var SA=X7(0);function l9(A){for(var M=A;M!==null;){if(M.tag===13){var Z=M.memoizedState;if(Z!==null&&(Z=Z.dehydrated,Z===null||ZQ(Z)||qQ(Z)))return M}else if(M.tag===19&&(M.memoizedProps.revealOrder==="forwards"||M.memoizedProps.revealOrder==="backwards"||M.memoizedProps.revealOrder==="unstable_legacy-backwards"||M.memoizedProps.revealOrder==="together")){if((M.flags&128)!==0)return M}else if(M.child!==null){M.child.return=M,M=M.child;continue}if(M===A)break;for(;M.sibling===null;){if(M.return===null||M.return===A)return null;M=M.return}M.sibling.return=M.return,M=M.sibling}return null}var p7=0,s=null,GA=null,hA=null,i9=!1,iq=!1,aZ=!1,r9=0,TY=0,rq=null,L5=0;function CA(){throw Error(w(321))}function bQ(A,M){if(M===null)return!1;for(var Z=0;Z<M.length&&Z<A.length;Z++)if(!xM(A[Z],M[Z]))return!1;return!0}function SQ(A,M,Z,q,z,Y){return p7=Y,s=M,M.memoizedState=null,M.updateQueue=null,M.lanes=0,f.H=A===null||A.memoizedState===null?rI:pQ,aZ=!1,Y=Z(q,z),aZ=!1,iq&&(Y=DI(M,Z,q,z)),KI(A),Y}function KI(A){f.H=KY;var M=GA!==null&&GA.next!==null;if(p7=0,hA=GA=s=null,i9=!1,TY=0,rq=null,M)throw Error(w(300));A===null||gA||(A=A.dependencies,A!==null&&d9(A)&&(gA=!0))}function DI(A,M,Z,q){s=A;var z=0;do{if(iq&&(rq=null),TY=0,iq=!1,25<=z)throw Error(w(301));if(z+=1,hA=GA=null,A.updateQueue!=null){var Y=A.updateQueue;Y.lastEffect=null,Y.events=null,Y.stores=null,Y.memoCache!=null&&(Y.memoCache.index=0)}f.H=sI,Y=M(Z,q)}while(iq);return Y}function w5(){var A=f.H,M=A.useState()[0];return M=typeof M.then==="function"?CY(M):M,A=A.useState()[0],(GA!==null?GA.memoizedState:null)!==A&&(s.flags|=1024),M}function PQ(){var A=r9!==0;return r9=0,A}function xQ(A,M,Z){M.updateQueue=A.updateQueue,M.flags&=-2053,A.lanes&=~Z}function yQ(A){if(i9){for(A=A.memoizedState;A!==null;){var M=A.queue;M!==null&&(M.pending=null),A=A.next}i9=!1}p7=0,hA=GA=s=null,iq=!1,TY=r9=0,rq=null}function BM(){var A={memoizedState:null,baseState:null,baseQueue:null,queue:null,next:null};return hA===null?s.memoizedState=hA=A:hA=hA.next=A,hA}function PA(){if(GA===null){var A=s.alternate;A=A!==null?A.memoizedState:null}else A=GA.next;var M=hA===null?s.memoizedState:hA.next;if(M!==null)hA=M,GA=A;else{if(A===null){if(s.alternate===null)throw Error(w(467));throw Error(w(310))}GA=A,A={memoizedState:GA.memoizedState,baseState:GA.baseState,baseQueue:GA.baseQueue,queue:GA.queue,next:null},hA===null?s.memoizedState=hA=A:hA=hA.next=A}return hA}function T3(){return{lastEffect:null,events:null,stores:null,memoCache:null}}function CY(A){var M=TY;return TY+=1,rq===null&&(rq=[]),A=BI(rq,A,M),M=s,(hA===null?M.memoizedState:hA.next)===null&&(M=M.alternate,f.H=M===null||M.memoizedState===null?rI:pQ),A}function K3(A){if(A!==null&&typeof A==="object"){if(typeof A.then==="function")return CY(A);if(A.$$typeof===h7)return eA(A)}throw Error(w(438,String(A)))}function hQ(A){var M=null,Z=s.updateQueue;if(Z!==null&&(M=Z.memoCache),M==null){var q=s.alternate;q!==null&&(q=q.updateQueue,q!==null&&(q=q.memoCache,q!=null&&(M={data:q.data.map(function(z){return z.slice()}),index:0})))}if(M==null&&(M={data:[],index:0}),Z===null&&(Z=T3(),s.updateQueue=Z),Z.memoCache=M,Z=M.data[M.index],Z===void 0)for(Z=M.data[M.index]=Array(A),q=0;q<A;q++)Z[q]=IK;return M.index++,Z}function c7(A,M){return typeof M==="function"?M(A):M}function H9(A){var M=PA();return vQ(M,GA,A)}function vQ(A,M,Z){var q=A.queue;if(q===null)throw Error(w(311));q.lastRenderedReducer=Z;var z=A.baseQueue,Y=q.pending;if(Y!==null){if(z!==null){var V=z.next;z.next=Y.next,Y.next=V}M.baseQueue=z=Y,q.pending=null}if(Y=A.baseState,z===null)A.memoizedState=Y;else{M=z.next;var Q=V=null,U=null,B=M,W=!1;do{var J=B.lane&-536870913;if(J!==B.lane?(t&J)===J:(p7&J)===J){var I=B.revertLane;if(I===0)U!==null&&(U=U.next={lane:0,revertLane:0,gesture:null,action:B.action,hasEagerState:B.hasEagerState,eagerState:B.eagerState,next:null}),J===nq&&(W=!0);else if((p7&I)===I){B=B.next,I===nq&&(W=!0);continue}else J={lane:0,revertLane:B.revertLane,gesture:null,action:B.action,hasEagerState:B.hasEagerState,eagerState:B.eagerState,next:null},U===null?(Q=U=J,V=Y):U=U.next=J,s.lanes|=I,HZ|=I;J=B.action,aZ&&Z(Y,J),Y=B.hasEagerState?B.eagerState:Z(Y,J)}else I={lane:J,revertLane:B.revertLane,gesture:B.gesture,action:B.action,hasEagerState:B.hasEagerState,eagerState:B.eagerState,next:null},U===null?(Q=U=I,V=Y):U=U.next=I,s.lanes|=J,HZ|=J;B=B.next}while(B!==null&&B!==M);if(U===null?V=Y:U.next=Q,!xM(Y,A.memoizedState)&&(gA=!0,W&&(Z=cq,Z!==null)))throw Z;A.memoizedState=Y,A.baseState=V,A.baseQueue=U,q.lastRenderedState=Y}return z===null&&(q.lanes=0),[A.memoizedState,q.dispatch]}function sV(A){var M=PA(),Z=M.queue;if(Z===null)throw Error(w(311));Z.lastRenderedReducer=A;var{dispatch:q,pending:z}=Z,Y=M.memoizedState;if(z!==null){Z.pending=null;var V=z=z.next;do Y=A(Y,V.action),V=V.next;while(V!==z);xM(Y,M.memoizedState)||(gA=!0),M.memoizedState=Y,M.baseQueue===null&&(M.baseState=Y),Z.lastRenderedState=Y}return[Y,q]}function NI(A,M,Z){var q=s,z=PA(),Y=e;if(Y){if(Z===void 0)throw Error(w(407));Z=Z()}else Z=M();var V=!xM((GA||z).memoizedState,Z);if(V&&(z.memoizedState=Z,gA=!0),z=z.queue,fQ(OI.bind(null,q,z,A),[A]),z.getSnapshot!==M||V||hA!==null&&hA.memoizedState.tag&1){if(q.flags|=2048,_q(9,{destroy:void 0},XI.bind(null,q,z,Z,M),null),JA===null)throw Error(w(349));Y||(p7&127)!==0||jI(q,M,Z)}return Z}function jI(A,M,Z){A.flags|=16384,A={getSnapshot:M,value:Z},M=s.updateQueue,M===null?(M=T3(),s.updateQueue=M,M.stores=[A]):(Z=M.stores,Z===null?M.stores=[A]:Z.push(A))}function XI(A,M,Z,q){M.value=Z,M.getSnapshot=q,EI(M)&&RI(A)}function OI(A,M,Z){return Z(function(){EI(M)&&RI(A)})}function EI(A){var M=A.getSnapshot;A=A.value;try{var Z=M();return!xM(A,Z)}catch(q){return!0}}function RI(A){var M=eZ(A,2);M!==null&&NM(M,A,2)}function f2(A){var M=BM();if(typeof A==="function"){var Z=A;if(A=Z(),aZ){VZ(!0);try{Z()}finally{VZ(!1)}}}return M.memoizedState=M.baseState=A,M.queue={pending:null,lanes:0,dispatch:null,lastRenderedReducer:c7,lastRenderedState:A},M}function HI(A,M,Z,q){return A.baseState=Z,vQ(A,GA,typeof q==="function"?q:c7)}function k5(A,M,Z,q,z){if(N3(A))throw Error(w(485));if(A=M.action,A!==null){var Y={payload:z,action:A,next:null,isTransition:!0,status:"pending",value:null,reason:null,listeners:[],then:function(V){Y.listeners.push(V)}};f.T!==null?Z(!0):Y.isTransition=!1,q(Y),Z=M.pending,Z===null?(Y.next=M.pending=Y,FI(M,Y)):(Y.next=Z.next,M.pending=Z.next=Y)}}function FI(A,M){var{action:Z,payload:q}=M,z=A.state;if(M.isTransition){var Y=f.T,V={};f.T=V;try{var Q=Z(z,q),U=f.S;U!==null&&U(V,Q),LB(A,M,Q)}catch(B){g2(A,M,B)}finally{Y!==null&&V.types!==null&&(Y.types=V.types),f.T=Y}}else try{Y=Z(z,q),LB(A,M,Y)}catch(B){g2(A,M,B)}}function LB(A,M,Z){Z!==null&&typeof Z==="object"&&typeof Z.then==="function"?Z.then(function(q){wB(A,M,q)},function(q){return g2(A,M,q)}):wB(A,M,Z)}function wB(A,M,Z){M.status="fulfilled",M.value=Z,LI(M),A.state=Z,M=A.pending,M!==null&&(Z=M.next,Z===M?A.pending=null:(Z=Z.next,M.next=Z,FI(A,Z)))}function g2(A,M,Z){var q=A.pending;if(A.pending=null,q!==null){q=q.next;do M.status="rejected",M.reason=Z,LI(M),M=M.next;while(M!==q)}A.action=null}function LI(A){A=A.listeners;for(var M=0;M<A.length;M++)(0,A[M])()}function wI(A,M){return M}function kB(A,M){if(e){var Z=JA.formState;if(Z!==null){A:{var q=s;if(e){if(jA){M:{var z=jA;for(var Y=rM;z.nodeType!==8;){if(!Y){z=null;break M}if(z=oM(z.nextSibling),z===null){z=null;break M}}Y=z.data,z=Y==="F!"||Y==="F"?z:null}if(z){jA=oM(z.nextSibling),q=z.data==="F!";break A}}EZ(q)}q=!1}q&&(M=Z[0])}}return Z=BM(),Z.memoizedState=Z.baseState=M,q={pending:null,lanes:0,dispatch:null,lastRenderedReducer:wI,lastRenderedState:M},Z.queue=q,Z=cI.bind(null,s,q),q.dispatch=Z,q=f2(!1),Y=dQ.bind(null,s,!1,q.queue),q=BM(),z={state:M,dispatch:null,action:A,pending:null},q.queue=z,Z=k5.bind(null,s,z,Y,Z),z.dispatch=Z,q.memoizedState=A,[M,Z,!1]}function CB(A){var M=PA();return kI(M,GA,A)}function kI(A,M,Z){if(M=vQ(A,M,wI)[0],A=H9(c7)[0],typeof M==="object"&&M!==null&&typeof M.then==="function")try{var q=CY(M)}catch(V){if(V===Vz)throw J3;throw V}else q=M;M=PA();var z=M.queue,Y=z.dispatch;return Z!==M.memoizedState&&(s.flags|=2048,_q(9,{destroy:void 0},C5.bind(null,z,Z),null)),[q,Y,A]}function C5(A,M){A.action=M}function bB(A){var M=PA(),Z=GA;if(Z!==null)return kI(M,Z,A);PA(),M=M.memoizedState,Z=PA();var q=Z.queue.dispatch;return Z.memoizedState=A,[M,q,!1]}function _q(A,M,Z,q){return A={tag:A,create:Z,deps:q,inst:M,next:null},M=s.updateQueue,M===null&&(M=T3(),s.updateQueue=M),Z=M.lastEffect,Z===null?M.lastEffect=A.next=A:(q=Z.next,Z.next=A,A.next=q,M.lastEffect=A),A}function CI(){return PA().memoizedState}function F9(A,M,Z,q){var z=BM();s.flags|=A,z.memoizedState=_q(1|M,{destroy:void 0},Z,q===void 0?null:q)}function D3(A,M,Z,q){var z=PA();q=q===void 0?null:q;var Y=z.memoizedState.inst;GA!==null&&q!==null&&bQ(q,GA.memoizedState.deps)?z.memoizedState=_q(M,Y,Z,q):(s.flags|=A,z.memoizedState=_q(1|M,Y,Z,q))}function SB(A,M){F9(8390656,8,A,M)}function fQ(A,M){D3(2048,8,A,M)}function b5(A){s.flags|=4;var M=s.updateQueue;if(M===null)M=T3(),s.updateQueue=M,M.events=[A];else{var Z=M.events;Z===null?M.events=[A]:Z.push(A)}}function bI(A){var M=PA().memoizedState;return b5({ref:M,nextImpl:A}),function(){if((qA&2)!==0)throw Error(w(440));return M.impl.apply(void 0,arguments)}}function SI(A,M){return D3(4,2,A,M)}function PI(A,M){return D3(4,4,A,M)}function xI(A,M){if(typeof M==="function"){A=A();var Z=M(A);return function(){typeof Z==="function"?Z():M(null)}}if(M!==null&&M!==void 0)return A=A(),M.current=A,function(){M.current=null}}function yI(A,M,Z){Z=Z!==null&&Z!==void 0?Z.concat([A]):null,D3(4,4,xI.bind(null,M,A),Z)}function gQ(){}function hI(A,M){var Z=PA();M=M===void 0?null:M;var q=Z.memoizedState;if(M!==null&&bQ(M,q[1]))return q[0];return Z.memoizedState=[A,M],A}function vI(A,M){var Z=PA();M=M===void 0?null:M;var q=Z.memoizedState;if(M!==null&&bQ(M,q[1]))return q[0];if(q=A(),aZ){VZ(!0);try{A()}finally{VZ(!1)}}return Z.memoizedState=[q,M],q}function uQ(A,M,Z){if(Z===void 0||(p7&1073741824)!==0&&(t&261930)===0)return A.memoizedState=M;return A.memoizedState=Z,A=H0(),s.lanes|=A,HZ|=A,Z}function fI(A,M,Z,q){if(xM(Z,M))return Z;if($q.current!==null)return A=uQ(A,Z,q),xM(A,M)||(gA=!0),A;if((p7&42)===0||(p7&1073741824)!==0&&(t&261930)===0)return gA=!0,A.memoizedState=Z;return A=H0(),s.lanes|=A,HZ|=A,M}function gI(A,M,Z,q,z){var Y=zA.p;zA.p=Y!==0&&8>Y?Y:8;var V=f.T,Q={};f.T=Q,dQ(A,!1,M,Z);try{var U=z(),B=f.S;if(B!==null&&B(Q,U),U!==null&&typeof U==="object"&&typeof U.then==="function"){var W=F5(U,q);MY(A,M,W,PM(A))}else MY(A,M,q,PM(A))}catch(J){MY(A,M,{then:function(){},status:"rejected",reason:J},PM())}finally{zA.p=Y,V!==null&&Q.types!==null&&(V.types=Q.types),f.T=V}}function S5(){}function u2(A,M,Z,q){if(A.tag!==5)throw Error(w(476));var z=uI(A).queue;gI(A,z,M,dZ,Z===null?S5:function(){return mI(A),Z(q)})}function uI(A){var M=A.memoizedState;if(M!==null)return M;M={memoizedState:dZ,baseState:dZ,baseQueue:null,queue:{pending:null,lanes:0,dispatch:null,lastRenderedReducer:c7,lastRenderedState:dZ},next:null};var Z={};return M.next={memoizedState:Z,baseState:Z,baseQueue:null,queue:{pending:null,lanes:0,dispatch:null,lastRenderedReducer:c7,lastRenderedState:Z},next:null},A.memoizedState=M,A=A.alternate,A!==null&&(A.memoizedState=M),M}function mI(A){var M=uI(A);M.next===null&&(M=A.alternate.memoizedState),MY(A,M.next.queue,{},PM())}function mQ(){return eA(jY)}function dI(){return PA().memoizedState}function pI(){return PA().memoizedState}function P5(A){for(var M=A.return;M!==null;){switch(M.tag){case 24:case 3:var Z=PM();A=JZ(Z);var q=TZ(M,A,Z);q!==null&&(NM(q,M,Z),tz(q,M,Z)),M={cache:FQ()},A.payload=M;return}M=M.return}}function x5(A,M,Z){var q=PM();Z={lane:q,revertLane:0,gesture:null,action:Z,hasEagerState:!1,eagerState:null,next:null},N3(A)?lI(M,Z):(Z=OQ(A,M,Z,q),Z!==null&&(NM(Z,A,q),iI(Z,M,q)))}function cI(A,M,Z){var q=PM();MY(A,M,Z,q)}function MY(A,M,Z,q){var z={lane:q,revertLane:0,gesture:null,action:Z,hasEagerState:!1,eagerState:null,next:null};if(N3(A))lI(M,z);else{var Y=A.alternate;if(A.lanes===0&&(Y===null||Y.lanes===0)&&(Y=M.lastRenderedReducer,Y!==null))try{var V=M.lastRenderedState,Q=Y(V,Z);if(z.hasEagerState=!0,z.eagerState=Q,xM(Q,V))return W3(A,M,z,0),JA===null&&I3(),!1}catch(U){}finally{}if(Z=OQ(A,M,z,q),Z!==null)return NM(Z,A,q),iI(Z,M,q),!0}return!1}function dQ(A,M,Z,q){if(q={lane:2,revertLane:nQ(),gesture:null,action:q,hasEagerState:!1,eagerState:null,next:null},N3(A)){if(M)throw Error(w(479))}else M=OQ(A,Z,q,2),M!==null&&NM(M,A,2)}function N3(A){var M=A.alternate;return A===s||M!==null&&M===s}function lI(A,M){iq=i9=!0;var Z=A.pending;Z===null?M.next=M:(M.next=Z.next,Z.next=M),A.pending=M}function iI(A,M,Z){if((Z&4194048)!==0){var q=M.lanes;q&=A.pendingLanes,Z|=q,M.lanes=Z,bG(A,Z)}}var KY={readContext:eA,use:K3,useCallback:CA,useContext:CA,useEffect:CA,useImperativeHandle:CA,useLayoutEffect:CA,useInsertionEffect:CA,useMemo:CA,useReducer:CA,useRef:CA,useState:CA,useDebugValue:CA,useDeferredValue:CA,useTransition:CA,useSyncExternalStore:CA,useId:CA,useHostTransitionStatus:CA,useFormState:CA,useActionState:CA,useOptimistic:CA,useMemoCache:CA,useCacheRefresh:CA};KY.useEffectEvent=CA;var rI={readContext:eA,use:K3,useCallback:function(A,M){return BM().memoizedState=[A,M===void 0?null:M],A},useContext:eA,useEffect:SB,useImperativeHandle:function(A,M,Z){Z=Z!==null&&Z!==void 0?Z.concat([A]):null,F9(4194308,4,xI.bind(null,M,A),Z)},useLayoutEffect:function(A,M){return F9(4194308,4,A,M)},useInsertionEffect:function(A,M){F9(4,2,A,M)},useMemo:function(A,M){var Z=BM();M=M===void 0?null:M;var q=A();if(aZ){VZ(!0);try{A()}finally{VZ(!1)}}return Z.memoizedState=[q,M],q},useReducer:function(A,M,Z){var q=BM();if(Z!==void 0){var z=Z(M);if(aZ){VZ(!0);try{Z(M)}finally{VZ(!1)}}}else z=M;return q.memoizedState=q.baseState=z,A={pending:null,lanes:0,dispatch:null,lastRenderedReducer:A,lastRenderedState:z},q.queue=A,A=A.dispatch=x5.bind(null,s,A),[q.memoizedState,A]},useRef:function(A){var M=BM();return A={current:A},M.memoizedState=A},useState:function(A){A=f2(A);var M=A.queue,Z=cI.bind(null,s,M);return M.dispatch=Z,[A.memoizedState,Z]},useDebugValue:gQ,useDeferredValue:function(A,M){var Z=BM();return uQ(Z,A,M)},useTransition:function(){var A=f2(!1);return A=gI.bind(null,s,A.queue,!0,!1),BM().memoizedState=A,[!1,A]},useSyncExternalStore:function(A,M,Z){var q=s,z=BM();if(e){if(Z===void 0)throw Error(w(407));Z=Z()}else{if(Z=M(),JA===null)throw Error(w(349));(t&127)!==0||jI(q,M,Z)}z.memoizedState=Z;var Y={value:Z,getSnapshot:M};return z.queue=Y,SB(OI.bind(null,q,Y,A),[A]),q.flags|=2048,_q(9,{destroy:void 0},XI.bind(null,q,Y,Z,M),null),Z},useId:function(){var A=BM(),M=JA.identifierPrefix;if(e){var Z=D7,q=K7;Z=(q&~(1<<32-SM(q)-1)).toString(32)+Z,M="_"+M+"R_"+Z,Z=r9++,0<Z&&(M+="H"+Z.toString(32)),M+="_"}else Z=L5++,M="_"+M+"r_"+Z.toString(32)+"_";return A.memoizedState=M},useHostTransitionStatus:mQ,useFormState:kB,useActionState:kB,useOptimistic:function(A){var M=BM();M.memoizedState=M.baseState=A;var Z={pending:null,lanes:0,dispatch:null,lastRenderedReducer:null,lastRenderedState:null};return M.queue=Z,M=dQ.bind(null,s,!0,Z),Z.dispatch=M,[A,M]},useMemoCache:hQ,useCacheRefresh:function(){return BM().memoizedState=P5.bind(null,s)},useEffectEvent:function(A){var M=BM(),Z={impl:A};return M.memoizedState=Z,function(){if((qA&2)!==0)throw Error(w(440));return Z.impl.apply(void 0,arguments)}}},pQ={readContext:eA,use:K3,useCallback:hI,useContext:eA,useEffect:fQ,useImperativeHandle:yI,useInsertionEffect:SI,useLayoutEffect:PI,useMemo:vI,useReducer:H9,useRef:CI,useState:function(){return H9(c7)},useDebugValue:gQ,useDeferredValue:function(A,M){var Z=PA();return fI(Z,GA.memoizedState,A,M)},useTransition:function(){var A=H9(c7)[0],M=PA().memoizedState;return[typeof A==="boolean"?A:CY(A),M]},useSyncExternalStore:NI,useId:dI,useHostTransitionStatus:mQ,useFormState:CB,useActionState:CB,useOptimistic:function(A,M){var Z=PA();return HI(Z,GA,A,M)},useMemoCache:hQ,useCacheRefresh:pI};pQ.useEffectEvent=bI;var sI={readContext:eA,use:K3,useCallback:hI,useContext:eA,useEffect:fQ,useImperativeHandle:yI,useInsertionEffect:SI,useLayoutEffect:PI,useMemo:vI,useReducer:sV,useRef:CI,useState:function(){return sV(c7)},useDebugValue:gQ,useDeferredValue:function(A,M){var Z=PA();return GA===null?uQ(Z,A,M):fI(Z,GA.memoizedState,A,M)},useTransition:function(){var A=sV(c7)[0],M=PA().memoizedState;return[typeof A==="boolean"?A:CY(A),M]},useSyncExternalStore:NI,useId:dI,useHostTransitionStatus:mQ,useFormState:bB,useActionState:bB,useOptimistic:function(A,M){var Z=PA();if(GA!==null)return HI(Z,GA,A,M);return Z.baseState=A,[A,Z.queue.dispatch]},useMemoCache:hQ,useCacheRefresh:pI};sI.useEffectEvent=bI;function oV(A,M,Z,q){M=A.memoizedState,Z=Z(q,M),Z=Z===null||Z===void 0?M:XA({},M,Z),A.memoizedState=Z,A.lanes===0&&(A.updateQueue.baseState=Z)}var m2={enqueueSetState:function(A,M,Z){A=A._reactInternals;var q=PM(),z=JZ(q);z.payload=M,Z!==void 0&&Z!==null&&(z.callback=Z),M=TZ(A,z,q),M!==null&&(NM(M,A,q),tz(M,A,q))},enqueueReplaceState:function(A,M,Z){A=A._reactInternals;var q=PM(),z=JZ(q);z.tag=1,z.payload=M,Z!==void 0&&Z!==null&&(z.callback=Z),M=TZ(A,z,q),M!==null&&(NM(M,A,q),tz(M,A,q))},enqueueForceUpdate:function(A,M){A=A._reactInternals;var Z=PM(),q=JZ(Z);q.tag=2,M!==void 0&&M!==null&&(q.callback=M),M=TZ(A,q,Z),M!==null&&(NM(M,A,Z),tz(M,A,Z))}};function PB(A,M,Z,q,z,Y,V){return A=A.stateNode,typeof A.shouldComponentUpdate==="function"?A.shouldComponentUpdate(q,Y,V):M.prototype&&M.prototype.isPureReactComponent?!GY(Z,q)||!GY(z,Y):!0}function xB(A,M,Z,q){A=M.state,typeof M.componentWillReceiveProps==="function"&&M.componentWillReceiveProps(Z,q),typeof M.UNSAFE_componentWillReceiveProps==="function"&&M.UNSAFE_componentWillReceiveProps(Z,q),M.state!==A&&m2.enqueueReplaceState(M,M.state,null)}function nZ(A,M){var Z=M;if("ref"in M){Z={};for(var q in M)q!=="ref"&&(Z[q]=M[q])}if(A=A.defaultProps){Z===M&&(Z=XA({},Z));for(var z in A)Z[z]===void 0&&(Z[z]=A[z])}return Z}function oI(A){g9(A)}function aI(A){console.error(A)}function nI(A){g9(A)}function s9(A,M){try{var Z=A.onUncaughtError;Z(M.value,{componentStack:M.stack})}catch(q){setTimeout(function(){throw q})}}function yB(A,M,Z){try{var q=A.onCaughtError;q(Z.value,{componentStack:Z.stack,errorBoundary:M.tag===1?M.stateNode:null})}catch(z){setTimeout(function(){throw z})}}function d2(A,M,Z){return Z=JZ(Z),Z.tag=3,Z.payload={element:null},Z.callback=function(){s9(A,M)},Z}function $I(A){return A=JZ(A),A.tag=3,A}function _I(A,M,Z,q){var z=Z.type.getDerivedStateFromError;if(typeof z==="function"){var Y=q.value;A.payload=function(){return z(Y)},A.callback=function(){yB(M,Z,q)}}var V=Z.stateNode;V!==null&&typeof V.componentDidCatch==="function"&&(A.callback=function(){yB(M,Z,q),typeof z!=="function"&&(KZ===null?KZ=new Set([this]):KZ.add(this));var Q=q.stack;this.componentDidCatch(q.value,{componentStack:Q!==null?Q:""})})}function y5(A,M,Z,q,z){if(Z.flags|=32768,q!==null&&typeof q==="object"&&typeof q.then==="function"){if(M=Z.alternate,M!==null&&Yz(M,Z,z,!0),Z=yM.current,Z!==null){switch(Z.tag){case 31:case 13:return sM===null?_9():Z.alternate===null&&bA===0&&(bA=3),Z.flags&=-257,Z.flags|=65536,Z.lanes=z,q===p9?Z.flags|=16384:(M=Z.updateQueue,M===null?Z.updateQueue=new Set([q]):M.add(q),z2(A,q,z)),!1;case 22:return Z.flags|=65536,q===p9?Z.flags|=16384:(M=Z.updateQueue,M===null?(M={transitions:null,markerInstances:null,retryQueue:new Set([q])},Z.updateQueue=M):(Z=M.retryQueue,Z===null?M.retryQueue=new Set([q]):Z.add(q)),z2(A,q,z)),!1}throw Error(w(435,Z.tag))}return z2(A,q,z),_9(),!1}if(e)return M=yM.current,M!==null?((M.flags&65536)===0&&(M.flags|=256),M.flags|=65536,M.lanes=z,q!==k2&&(A=Error(w(422),{cause:q}),WY(iM(A,Z)))):(q!==k2&&(M=Error(w(423),{cause:q}),WY(iM(M,Z))),A=A.current.alternate,A.flags|=65536,z&=-z,A.lanes|=z,q=iM(q,Z),z=d2(A.stateNode,q,z),rV(A,z),bA!==4&&(bA=2)),!1;var Y=Error(w(520),{cause:q});if(Y=iM(Y,Z),zY===null?zY=[Y]:zY.push(Y),bA!==4&&(bA=2),M===null)return!0;q=iM(q,Z),Z=M;do{switch(Z.tag){case 3:return Z.flags|=65536,A=z&-z,Z.lanes|=A,A=d2(Z.stateNode,q,A),rV(Z,A),!1;case 1:if(M=Z.type,Y=Z.stateNode,(Z.flags&128)===0&&(typeof M.getDerivedStateFromError==="function"||Y!==null&&typeof Y.componentDidCatch==="function"&&(KZ===null||!KZ.has(Y))))return Z.flags|=65536,z&=-z,Z.lanes|=z,z=$I(z),_I(z,A,Z,q),rV(Z,z),!1}Z=Z.return}while(Z!==null);return!1}var cQ=Error(w(461)),gA=!1;function $A(A,M,Z,q){M.child=A===null?II(M,null,Z,q):oZ(M,A.child,Z,q)}function hB(A,M,Z,q,z){Z=Z.render;var Y=M.ref;if("ref"in q){var V={};for(var Q in q)Q!=="ref"&&(V[Q]=q[Q])}else V=q;if(sZ(M),q=SQ(A,M,Z,V,Y,z),Q=PQ(),A!==null&&!gA)return xQ(A,M,z),l7(A,M,z);return e&&Q&&RQ(M),M.flags|=1,$A(A,M,q,z),M.child}function vB(A,M,Z,q,z){if(A===null){var Y=Z.type;if(typeof Y==="function"&&!EQ(Y)&&Y.defaultProps===void 0&&Z.compare===null)return M.tag=15,M.type=Y,tI(A,M,Y,q,z);return A=E9(Z.type,null,q,M,M.mode,z),A.ref=M.ref,A.return=M,M.child=A}if(Y=A.child,!lQ(A,z)){var V=Y.memoizedProps;if(Z=Z.compare,Z=Z!==null?Z:GY,Z(V,q)&&A.ref===M.ref)return l7(A,M,z)}return M.flags|=1,A=g7(Y,q),A.ref=M.ref,A.return=M,M.child=A}function tI(A,M,Z,q,z){if(A!==null){var Y=A.memoizedProps;if(GY(Y,q)&&A.ref===M.ref)if(gA=!1,M.pendingProps=q=Y,lQ(A,z))(A.flags&131072)!==0&&(gA=!0);else return M.lanes=A.lanes,l7(A,M,z)}return p2(A,M,Z,q,z)}function eI(A,M,Z,q){var z=q.children,Y=A!==null?A.memoizedState:null;if(A===null&&M.stateNode===null&&(M.stateNode={_visibility:1,_pendingMarkers:null,_retryCache:null,_transitions:null}),q.mode==="hidden"){if((M.flags&128)!==0){if(Y=Y!==null?Y.baseLanes|Z:Z,A!==null){q=M.child=A.child;for(z=0;q!==null;)z=z|q.lanes|q.childLanes,q=q.sibling;q=z&~Y}else q=0,M.child=null;return fB(A,M,Y,Z,q)}if((Z&536870912)!==0)M.memoizedState={baseLanes:0,cachePool:null},A!==null&&R9(M,Y!==null?Y.cachePool:null),Y!==null?FB(M,Y):h2(),TI(M);else return q=M.lanes=536870912,fB(A,M,Y!==null?Y.baseLanes|Z:Z,Z,q)}else Y!==null?(R9(M,Y.cachePool),FB(M,Y),zZ(M),M.memoizedState=null):(A!==null&&R9(M,null),h2(),zZ(M));return $A(A,M,z,Z),M.child}function iz(A,M){return A!==null&&A.tag===22||M.stateNode!==null||(M.stateNode={_visibility:1,_pendingMarkers:null,_retryCache:null,_transitions:null}),M.sibling}function fB(A,M,Z,q,z){var Y=LQ();return Y=Y===null?null:{parent:fA._currentValue,pool:Y},M.memoizedState={baseLanes:Z,cachePool:Y},A!==null&&R9(M,null),h2(),TI(M),A!==null&&Yz(A,M,q,!0),M.childLanes=z,null}function L9(A,M){return M=o9({mode:M.mode,children:M.children},A.mode),M.ref=A.ref,A.child=M,M.return=A,M}function gB(A,M,Z){return oZ(M,A.child,null,Z),A=L9(M,M.pendingProps),A.flags|=2,LM(M),M.memoizedState=null,A}function h5(A,M,Z){var q=M.pendingProps,z=(M.flags&128)!==0;if(M.flags&=-129,A===null){if(e){if(q.mode==="hidden")return A=L9(M,q),M.lanes=536870912,iz(null,A);if(v2(M),(A=jA)?(A=r0(A,rM),A=A!==null&&A.data==="&"?A:null,A!==null&&(M.memoizedState={dehydrated:A,treeContext:OZ!==null?{id:K7,overflow:D7}:null,retryLane:536870912,hydrationErrors:null},Z=zI(A),Z.return=M,M.child=Z,tA=M,jA=null)):A=null,A===null)throw EZ(M);return M.lanes=536870912,null}return L9(M,q)}var Y=A.memoizedState;if(Y!==null){var V=Y.dehydrated;if(v2(M),z)if(M.flags&256)M.flags&=-257,M=gB(A,M,Z);else if(M.memoizedState!==null)M.child=A.child,M.flags|=128,M=null;else throw Error(w(558));else if(gA||Yz(A,M,Z,!1),z=(Z&A.childLanes)!==0,gA||z){if(q=JA,q!==null&&(V=SG(q,Z),V!==0&&V!==Y.retryLane))throw Y.retryLane=V,eZ(A,V),NM(q,A,V),cQ;_9(),M=gB(A,M,Z)}else A=Y.treeContext,jA=oM(V.nextSibling),tA=M,e=!0,WZ=null,rM=!1,A!==null&&VI(M,A),M=L9(M,q),M.flags|=4096;return M}return A=g7(A.child,{mode:q.mode,children:q.children}),A.ref=M.ref,M.child=A,A.return=M,A}function w9(A,M){var Z=M.ref;if(Z===null)A!==null&&A.ref!==null&&(M.flags|=4194816);else{if(typeof Z!=="function"&&typeof Z!=="object")throw Error(w(284));if(A===null||A.ref!==Z)M.flags|=4194816}}function p2(A,M,Z,q,z){if(sZ(M),Z=SQ(A,M,Z,q,void 0,z),q=PQ(),A!==null&&!gA)return xQ(A,M,z),l7(A,M,z);return e&&q&&RQ(M),M.flags|=1,$A(A,M,Z,z),M.child}function uB(A,M,Z,q,z,Y){if(sZ(M),M.updateQueue=null,Z=DI(M,q,Z,z),KI(A),q=PQ(),A!==null&&!gA)return xQ(A,M,Y),l7(A,M,Y);return e&&q&&RQ(M),M.flags|=1,$A(A,M,Z,Y),M.child}function mB(A,M,Z,q,z){if(sZ(M),M.stateNode===null){var Y=vq,V=Z.contextType;typeof V==="object"&&V!==null&&(Y=eA(V)),Y=new Z(q,Y),M.memoizedState=Y.state!==null&&Y.state!==void 0?Y.state:null,Y.updater=m2,M.stateNode=Y,Y._reactInternals=M,Y=M.stateNode,Y.props=q,Y.state=M.memoizedState,Y.refs={},kQ(M),V=Z.contextType,Y.context=typeof V==="object"&&V!==null?eA(V):vq,Y.state=M.memoizedState,V=Z.getDerivedStateFromProps,typeof V==="function"&&(oV(M,Z,V,q),Y.state=M.memoizedState),typeof Z.getDerivedStateFromProps==="function"||typeof Y.getSnapshotBeforeUpdate==="function"||typeof Y.UNSAFE_componentWillMount!=="function"&&typeof Y.componentWillMount!=="function"||(V=Y.state,typeof Y.componentWillMount==="function"&&Y.componentWillMount(),typeof Y.UNSAFE_componentWillMount==="function"&&Y.UNSAFE_componentWillMount(),V!==Y.state&&m2.enqueueReplaceState(Y,Y.state,null),AY(M,q,Y,z),ez(),Y.state=M.memoizedState),typeof Y.componentDidMount==="function"&&(M.flags|=4194308),q=!0}else if(A===null){Y=M.stateNode;var Q=M.memoizedProps,U=nZ(Z,Q);Y.props=U;var B=Y.context,W=Z.contextType;V=vq,typeof W==="object"&&W!==null&&(V=eA(W));var J=Z.getDerivedStateFromProps;W=typeof J==="function"||typeof Y.getSnapshotBeforeUpdate==="function",Q=M.pendingProps!==Q,W||typeof Y.UNSAFE_componentWillReceiveProps!=="function"&&typeof Y.componentWillReceiveProps!=="function"||(Q||B!==V)&&xB(M,Y,q,V),MZ=!1;var I=M.memoizedState;Y.state=I,AY(M,q,Y,z),ez(),B=M.memoizedState,Q||I!==B||MZ?(typeof J==="function"&&(oV(M,Z,J,q),B=M.memoizedState),(U=MZ||PB(M,Z,U,q,I,B,V))?(W||typeof Y.UNSAFE_componentWillMount!=="function"&&typeof Y.componentWillMount!=="function"||(typeof Y.componentWillMount==="function"&&Y.componentWillMount(),typeof Y.UNSAFE_componentWillMount==="function"&&Y.UNSAFE_componentWillMount()),typeof Y.componentDidMount==="function"&&(M.flags|=4194308)):(typeof Y.componentDidMount==="function"&&(M.flags|=4194308),M.memoizedProps=q,M.memoizedState=B),Y.props=q,Y.state=B,Y.context=V,q=U):(typeof Y.componentDidMount==="function"&&(M.flags|=4194308),q=!1)}else{Y=M.stateNode,x2(A,M),V=M.memoizedProps,W=nZ(Z,V),Y.props=W,J=M.pendingProps,I=Y.context,B=Z.contextType,U=vq,typeof B==="object"&&B!==null&&(U=eA(B)),Q=Z.getDerivedStateFromProps,(B=typeof Q==="function"||typeof Y.getSnapshotBeforeUpdate==="function")||typeof Y.UNSAFE_componentWillReceiveProps!=="function"&&typeof Y.componentWillReceiveProps!=="function"||(V!==J||I!==U)&&xB(M,Y,q,U),MZ=!1,I=M.memoizedState,Y.state=I,AY(M,q,Y,z),ez();var K=M.memoizedState;V!==J||I!==K||MZ||A!==null&&A.dependencies!==null&&d9(A.dependencies)?(typeof Q==="function"&&(oV(M,Z,Q,q),K=M.memoizedState),(W=MZ||PB(M,Z,W,q,I,K,U)||A!==null&&A.dependencies!==null&&d9(A.dependencies))?(B||typeof Y.UNSAFE_componentWillUpdate!=="function"&&typeof Y.componentWillUpdate!=="function"||(typeof Y.componentWillUpdate==="function"&&Y.componentWillUpdate(q,K,U),typeof Y.UNSAFE_componentWillUpdate==="function"&&Y.UNSAFE_componentWillUpdate(q,K,U)),typeof Y.componentDidUpdate==="function"&&(M.flags|=4),typeof Y.getSnapshotBeforeUpdate==="function"&&(M.flags|=1024)):(typeof Y.componentDidUpdate!=="function"||V===A.memoizedProps&&I===A.memoizedState||(M.flags|=4),typeof Y.getSnapshotBeforeUpdate!=="function"||V===A.memoizedProps&&I===A.memoizedState||(M.flags|=1024),M.memoizedProps=q,M.memoizedState=K),Y.props=q,Y.state=K,Y.context=U,q=W):(typeof Y.componentDidUpdate!=="function"||V===A.memoizedProps&&I===A.memoizedState||(M.flags|=4),typeof Y.getSnapshotBeforeUpdate!=="function"||V===A.memoizedProps&&I===A.memoizedState||(M.flags|=1024),q=!1)}return Y=q,w9(A,M),q=(M.flags&128)!==0,Y||q?(Y=M.stateNode,Z=q&&typeof Z.getDerivedStateFromError!=="function"?null:Y.render(),M.flags|=1,A!==null&&q?(M.child=oZ(M,A.child,null,z),M.child=oZ(M,null,Z,z)):$A(A,M,Z,z),M.memoizedState=Y.state,A=M.child):A=l7(A,M,z),A}function dB(A,M,Z,q){return rZ(),M.flags|=256,$A(A,M,Z,q),M.child}var aV={dehydrated:null,treeContext:null,retryLane:0,hydrationErrors:null};function nV(A){return{baseLanes:A,cachePool:UI()}}function $V(A,M,Z){return A=A!==null?A.childLanes&~Z:0,M&&(A|=kM),A}function A0(A,M,Z){var q=M.pendingProps,z=!1,Y=(M.flags&128)!==0,V;if((V=Y)||(V=A!==null&&A.memoizedState===null?!1:(SA.current&2)!==0),V&&(z=!0,M.flags&=-129),V=(M.flags&32)!==0,M.flags&=-33,A===null){if(e){if(z?qZ(M):zZ(M),(A=jA)?(A=r0(A,rM),A=A!==null&&A.data!=="&"?A:null,A!==null&&(M.memoizedState={dehydrated:A,treeContext:OZ!==null?{id:K7,overflow:D7}:null,retryLane:536870912,hydrationErrors:null},Z=zI(A),Z.return=M,M.child=Z,tA=M,jA=null)):A=null,A===null)throw EZ(M);return qQ(A)?M.lanes=32:M.lanes=536870912,null}var Q=q.children;if(q=q.fallback,z)return zZ(M),z=M.mode,Q=o9({mode:"hidden",children:Q},z),q=pZ(q,z,Z,null),Q.return=M,q.return=M,Q.sibling=q,M.child=Q,q=M.child,q.memoizedState=nV(Z),q.childLanes=$V(A,V,Z),M.memoizedState=aV,iz(null,q);return qZ(M),c2(M,Q)}var U=A.memoizedState;if(U!==null&&(Q=U.dehydrated,Q!==null)){if(Y)M.flags&256?(qZ(M),M.flags&=-257,M=_V(A,M,Z)):M.memoizedState!==null?(zZ(M),M.child=A.child,M.flags|=128,M=null):(zZ(M),Q=q.fallback,z=M.mode,q=o9({mode:"visible",children:q.children},z),Q=pZ(Q,z,Z,null),Q.flags|=2,q.return=M,Q.return=M,q.sibling=Q,M.child=q,oZ(M,A.child,null,Z),q=M.child,q.memoizedState=nV(Z),q.childLanes=$V(A,V,Z),M.memoizedState=aV,M=iz(null,q));else if(qZ(M),qQ(Q)){if(V=Q.nextSibling&&Q.nextSibling.dataset,V)var B=V.dgst;V=B,q=Error(w(419)),q.stack="",q.digest=V,WY({value:q,source:null,stack:null}),M=_V(A,M,Z)}else if(gA||Yz(A,M,Z,!1),V=(Z&A.childLanes)!==0,gA||V){if(V=JA,V!==null&&(q=SG(V,Z),q!==0&&q!==U.retryLane))throw U.retryLane=q,eZ(A,q),NM(V,A,q),cQ;ZQ(Q)||_9(),M=_V(A,M,Z)}else ZQ(Q)?(M.flags|=192,M.child=A.child,M=null):(A=U.treeContext,jA=oM(Q.nextSibling),tA=M,e=!0,WZ=null,rM=!1,A!==null&&VI(M,A),M=c2(M,q.children),M.flags|=4096);return M}if(z)return zZ(M),Q=q.fallback,z=M.mode,U=A.child,B=U.sibling,q=g7(U,{mode:"hidden",children:q.children}),q.subtreeFlags=U.subtreeFlags&65011712,B!==null?Q=g7(B,Q):(Q=pZ(Q,z,Z,null),Q.flags|=2),Q.return=M,q.return=M,q.sibling=Q,M.child=q,iz(null,q),q=M.child,Q=A.child.memoizedState,Q===null?Q=nV(Z):(z=Q.cachePool,z!==null?(U=fA._currentValue,z=z.parent!==U?{parent:U,pool:U}:z):z=UI(),Q={baseLanes:Q.baseLanes|Z,cachePool:z}),q.memoizedState=Q,q.childLanes=$V(A,V,Z),M.memoizedState=aV,iz(A.child,q);return qZ(M),Z=A.child,A=Z.sibling,Z=g7(Z,{mode:"visible",children:q.children}),Z.return=M,Z.sibling=null,A!==null&&(V=M.deletions,V===null?(M.deletions=[A],M.flags|=16):V.push(A)),M.child=Z,M.memoizedState=null,Z}function c2(A,M){return M=o9({mode:"visible",children:M},A.mode),M.return=A,A.child=M}function o9(A,M){return A=wM(22,A,null,M),A.lanes=0,A}function _V(A,M,Z){return oZ(M,A.child,null,Z),A=c2(M,M.pendingProps.children),A.flags|=2,M.memoizedState=null,A}function pB(A,M,Z){A.lanes|=M;var q=A.alternate;q!==null&&(q.lanes|=M),b2(A.return,M,Z)}function tV(A,M,Z,q,z,Y){var V=A.memoizedState;V===null?A.memoizedState={isBackwards:M,rendering:null,renderingStartTime:0,last:q,tail:Z,tailMode:z,treeForkCount:Y}:(V.isBackwards=M,V.rendering=null,V.renderingStartTime=0,V.last=q,V.tail=Z,V.tailMode=z,V.treeForkCount=Y)}function M0(A,M,Z){var q=M.pendingProps,z=q.revealOrder,Y=q.tail;q=q.children;var V=SA.current,Q=(V&2)!==0;if(Q?(V=V&1|2,M.flags|=128):V&=1,TA(SA,V),$A(A,M,q,Z),q=e?IY:0,!Q&&A!==null&&(A.flags&128)!==0)A:for(A=M.child;A!==null;){if(A.tag===13)A.memoizedState!==null&&pB(A,Z,M);else if(A.tag===19)pB(A,Z,M);else if(A.child!==null){A.child.return=A,A=A.child;continue}if(A===M)break A;for(;A.sibling===null;){if(A.return===null||A.return===M)break A;A=A.return}A.sibling.return=A.return,A=A.sibling}switch(z){case"forwards":Z=M.child;for(z=null;Z!==null;)A=Z.alternate,A!==null&&l9(A)===null&&(z=Z),Z=Z.sibling;Z=z,Z===null?(z=M.child,M.child=null):(z=Z.sibling,Z.sibling=null),tV(M,!1,z,Z,Y,q);break;case"backwards":case"unstable_legacy-backwards":Z=null,z=M.child;for(M.child=null;z!==null;){if(A=z.alternate,A!==null&&l9(A)===null){M.child=z;break}A=z.sibling,z.sibling=Z,Z=z,z=A}tV(M,!0,Z,null,Y,q);break;case"together":tV(M,!1,null,null,void 0,q);break;default:M.memoizedState=null}return M.child}function l7(A,M,Z){if(A!==null&&(M.dependencies=A.dependencies),HZ|=M.lanes,(Z&M.childLanes)===0)if(A!==null){if(Yz(A,M,Z,!1),(Z&M.childLanes)===0)return null}else return null;if(A!==null&&M.child!==A.child)throw Error(w(153));if(M.child!==null){A=M.child,Z=g7(A,A.pendingProps),M.child=Z;for(Z.return=M;A.sibling!==null;)A=A.sibling,Z=Z.sibling=g7(A,A.pendingProps),Z.return=M;Z.sibling=null}return M.child}function lQ(A,M){if((A.lanes&M)!==0)return!0;return A=A.dependencies,A!==null&&d9(A)?!0:!1}function v5(A,M,Z){switch(M.tag){case 3:y9(M,M.stateNode.containerInfo),ZZ(M,fA,A.memoizedState.cache),rZ();break;case 27:case 5:D2(M);break;case 4:y9(M,M.stateNode.containerInfo);break;case 10:ZZ(M,M.type,M.memoizedProps.value);break;case 31:if(M.memoizedState!==null)return M.flags|=128,v2(M),null;break;case 13:var q=M.memoizedState;if(q!==null){if(q.dehydrated!==null)return qZ(M),M.flags|=128,null;if((Z&M.child.childLanes)!==0)return A0(A,M,Z);return qZ(M),A=l7(A,M,Z),A!==null?A.sibling:null}qZ(M);break;case 19:var z=(A.flags&128)!==0;if(q=(Z&M.childLanes)!==0,q||(Yz(A,M,Z,!1),q=(Z&M.childLanes)!==0),z){if(q)return M0(A,M,Z);M.flags|=128}if(z=M.memoizedState,z!==null&&(z.rendering=null,z.tail=null,z.lastEffect=null),TA(SA,SA.current),q)break;else return null;case 22:return M.lanes=0,eI(A,M,Z,M.pendingProps);case 24:ZZ(M,fA,A.memoizedState.cache)}return l7(A,M,Z)}function Z0(A,M,Z){if(A!==null)if(A.memoizedProps!==M.pendingProps)gA=!0;else{if(!lQ(A,Z)&&(M.flags&128)===0)return gA=!1,v5(A,M,Z);gA=(A.flags&131072)!==0?!0:!1}else gA=!1,e&&(M.flags&1048576)!==0&&YI(M,IY,M.index);switch(M.lanes=0,M.tag){case 16:A:{var q=M.pendingProps;if(A=uZ(M.elementType),M.type=A,typeof A==="function")EQ(A)?(q=nZ(A,q),M.tag=1,M=mB(null,M,A,q,Z)):(M.tag=0,M=p2(null,M,A,q,Z));else{if(A!==void 0&&A!==null){var z=A.$$typeof;if(z===QQ){M.tag=11,M=hB(null,M,A,q,Z);break A}else if(z===UQ){M.tag=14,M=vB(null,M,A,q,Z);break A}}throw M=T2(A)||A,Error(w(306,M,""))}}return M;case 0:return p2(A,M,M.type,M.pendingProps,Z);case 1:return q=M.type,z=nZ(q,M.pendingProps),mB(A,M,q,z,Z);case 3:A:{if(y9(M,M.stateNode.containerInfo),A===null)throw Error(w(387));q=M.pendingProps;var Y=M.memoizedState;z=Y.element,x2(A,M),AY(M,q,null,Z);var V=M.memoizedState;if(q=V.cache,ZZ(M,fA,q),q!==Y.cache&&S2(M,[fA],Z,!0),ez(),q=V.element,Y.isDehydrated)if(Y={element:q,isDehydrated:!1,cache:V.cache},M.updateQueue.baseState=Y,M.memoizedState=Y,M.flags&256){M=dB(A,M,q,Z);break A}else if(q!==z){z=iM(Error(w(424)),M),WY(z),M=dB(A,M,q,Z);break A}else{switch(A=M.stateNode.containerInfo,A.nodeType){case 9:A=A.body;break;default:A=A.nodeName==="HTML"?A.ownerDocument.body:A}jA=oM(A.firstChild),tA=M,e=!0,WZ=null,rM=!0,Z=II(M,null,q,Z);for(M.child=Z;Z;)Z.flags=Z.flags&-3|4096,Z=Z.sibling}else{if(rZ(),q===z){M=l7(A,M,Z);break A}$A(A,M,q,Z)}M=M.child}return M;case 26:return w9(A,M),A===null?(Z=QG(M.type,null,M.pendingProps,null))?M.memoizedState=Z:e||(Z=M.type,A=M.pendingProps,q=M3(IZ.current).createElement(Z),q[_A]=M,q[jM]=A,AM(q,Z,A),rA(q),M.stateNode=q):M.memoizedState=QG(M.type,A.memoizedProps,M.pendingProps,A.memoizedState),null;case 27:return D2(M),A===null&&e&&(q=M.stateNode=s0(M.type,M.pendingProps,IZ.current),tA=M,rM=!0,z=jA,LZ(M.type)?(zQ=z,jA=oM(q.firstChild)):jA=z),$A(A,M,M.pendingProps.children,Z),w9(A,M),A===null&&(M.flags|=4194304),M.child;case 5:if(A===null&&e){if(z=q=jA)q=BD(q,M.type,M.pendingProps,rM),q!==null?(M.stateNode=q,tA=M,jA=oM(q.firstChild),rM=!1,z=!0):z=!1;z||EZ(M)}return D2(M),z=M.type,Y=M.pendingProps,V=A!==null?A.memoizedProps:null,q=Y.children,AQ(z,Y)?q=null:V!==null&&AQ(z,V)&&(M.flags|=32),M.memoizedState!==null&&(z=SQ(A,M,w5,null,null,Z),jY._currentValue=z),w9(A,M),$A(A,M,q,Z),M.child;case 6:if(A===null&&e){if(A=Z=jA)Z=GD(Z,M.pendingProps,rM),Z!==null?(M.stateNode=Z,tA=M,jA=null,A=!0):A=!1;A||EZ(M)}return null;case 13:return A0(A,M,Z);case 4:return y9(M,M.stateNode.containerInfo),q=M.pendingProps,A===null?M.child=oZ(M,null,q,Z):$A(A,M,q,Z),M.child;case 11:return hB(A,M,M.type,M.pendingProps,Z);case 7:return $A(A,M,M.pendingProps,Z),M.child;case 8:return $A(A,M,M.pendingProps.children,Z),M.child;case 12:return $A(A,M,M.pendingProps.children,Z),M.child;case 10:return q=M.pendingProps,ZZ(M,M.type,q.value),$A(A,M,q.children,Z),M.child;case 9:return z=M.type._context,q=M.pendingProps.children,sZ(M),z=eA(z),q=q(z),M.flags|=1,$A(A,M,q,Z),M.child;case 14:return vB(A,M,M.type,M.pendingProps,Z);case 15:return tI(A,M,M.type,M.pendingProps,Z);case 19:return M0(A,M,Z);case 31:return h5(A,M,Z);case 22:return eI(A,M,Z,M.pendingProps);case 24:return sZ(M),q=eA(fA),A===null?(z=LQ(),z===null&&(z=JA,Y=FQ(),z.pooledCache=Y,Y.refCount++,Y!==null&&(z.pooledCacheLanes|=Z),z=Y),M.memoizedState={parent:q,cache:z},kQ(M),ZZ(M,fA,z)):((A.lanes&Z)!==0&&(x2(A,M),AY(M,null,null,Z),ez()),z=A.memoizedState,Y=M.memoizedState,z.parent!==q?(z={parent:q,cache:q},M.memoizedState=z,M.lanes===0&&(M.memoizedState=M.updateQueue.baseState=z),ZZ(M,fA,q)):(q=Y.cache,ZZ(M,fA,q),q!==z.cache&&S2(M,[fA],Z,!0))),$A(A,M,M.pendingProps.children,Z),M.child;case 29:throw M.pendingProps}throw Error(w(156,M.tag))}function C7(A){A.flags|=4}function eV(A,M,Z,q,z){if(M=(A.mode&32)!==0)M=!1;if(M){if(A.flags|=16777216,(z&335544128)===z)if(A.stateNode.complete)A.flags|=8192;else if(w0())A.flags|=8192;else throw lZ=p9,wQ}else A.flags&=-16777217}function cB(A,M){if(M.type!=="stylesheet"||(M.state.loading&4)!==0)A.flags&=-16777217;else if(A.flags|=16777216,!n0(M))if(w0())A.flags|=8192;else throw lZ=p9,wQ}function I9(A,M){M!==null&&(A.flags|=4),A.flags&16384&&(M=A.tag!==22?kG():536870912,A.lanes|=M,tq|=M)}function fz(A,M){if(!e)switch(A.tailMode){case"hidden":M=A.tail;for(var Z=null;M!==null;)M.alternate!==null&&(Z=M),M=M.sibling;Z===null?A.tail=null:Z.sibling=null;break;case"collapsed":Z=A.tail;for(var q=null;Z!==null;)Z.alternate!==null&&(q=Z),Z=Z.sibling;q===null?M||A.tail===null?A.tail=null:A.tail.sibling=null:q.sibling=null}}function NA(A){var M=A.alternate!==null&&A.alternate.child===A.child,Z=0,q=0;if(M)for(var z=A.child;z!==null;)Z|=z.lanes|z.childLanes,q|=z.subtreeFlags&65011712,q|=z.flags&65011712,z.return=A,z=z.sibling;else for(z=A.child;z!==null;)Z|=z.lanes|z.childLanes,q|=z.subtreeFlags,q|=z.flags,z.return=A,z=z.sibling;return A.subtreeFlags|=q,A.childLanes=Z,M}function f5(A,M,Z){var q=M.pendingProps;switch(HQ(M),M.tag){case 16:case 15:case 0:case 11:case 7:case 8:case 12:case 9:case 14:return NA(M),null;case 1:return NA(M),null;case 3:if(Z=M.stateNode,q=null,A!==null&&(q=A.memoizedState.cache),M.memoizedState.cache!==q&&(M.flags|=2048),u7(fA),sq(),Z.pendingContext&&(Z.context=Z.pendingContext,Z.pendingContext=null),A===null||A.child===null)Rq(M)?C7(M):A===null||A.memoizedState.isDehydrated&&(M.flags&256)===0||(M.flags|=1024,iV());return NA(M),null;case 26:var{type:z,memoizedState:Y}=M;return A===null?(C7(M),Y!==null?(NA(M),cB(M,Y)):(NA(M),eV(M,z,null,q,Z))):Y?Y!==A.memoizedState?(C7(M),NA(M),cB(M,Y)):(NA(M),M.flags&=-16777217):(A=A.memoizedProps,A!==q&&C7(M),NA(M),eV(M,z,A,q,Z)),null;case 27:if(h9(M),Z=IZ.current,z=M.type,A!==null&&M.stateNode!=null)A.memoizedProps!==q&&C7(M);else{if(!q){if(M.stateNode===null)throw Error(w(166));return NA(M),null}A=j7.current,Rq(M)?NB(M,A):(A=s0(z,q,Z),M.stateNode=A,C7(M))}return NA(M),null;case 5:if(h9(M),z=M.type,A!==null&&M.stateNode!=null)A.memoizedProps!==q&&C7(M);else{if(!q){if(M.stateNode===null)throw Error(w(166));return NA(M),null}if(Y=j7.current,Rq(M))NB(M,Y);else{var V=M3(IZ.current);switch(Y){case 1:Y=V.createElementNS("http://www.w3.org/2000/svg",z);break;case 2:Y=V.createElementNS("http://www.w3.org/1998/Math/MathML",z);break;default:switch(z){case"svg":Y=V.createElementNS("http://www.w3.org/2000/svg",z);break;case"math":Y=V.createElementNS("http://www.w3.org/1998/Math/MathML",z);break;case"script":Y=V.createElement("div"),Y.innerHTML="<script><\/script>",Y=Y.removeChild(Y.firstChild);break;case"select":Y=typeof q.is==="string"?V.createElement("select",{is:q.is}):V.createElement("select"),q.multiple?Y.multiple=!0:q.size&&(Y.size=q.size);break;default:Y=typeof q.is==="string"?V.createElement(z,{is:q.is}):V.createElement(z)}}Y[_A]=M,Y[jM]=q;A:for(V=M.child;V!==null;){if(V.tag===5||V.tag===6)Y.appendChild(V.stateNode);else if(V.tag!==4&&V.tag!==27&&V.child!==null){V.child.return=V,V=V.child;continue}if(V===M)break A;for(;V.sibling===null;){if(V.return===null||V.return===M)break A;V=V.return}V.sibling.return=V.return,V=V.sibling}M.stateNode=Y;A:switch(AM(Y,z,q),z){case"button":case"input":case"select":case"textarea":q=!!q.autoFocus;break A;case"img":q=!0;break A;default:q=!1}q&&C7(M)}}return NA(M),eV(M,M.type,A===null?null:A.memoizedProps,M.pendingProps,Z),null;case 6:if(A&&M.stateNode!=null)A.memoizedProps!==q&&C7(M);else{if(typeof q!=="string"&&M.stateNode===null)throw Error(w(166));if(A=IZ.current,Rq(M)){if(A=M.stateNode,Z=M.memoizedProps,q=null,z=tA,z!==null)switch(z.tag){case 27:case 5:q=z.memoizedProps}A[_A]=M,A=A.nodeValue===Z||q!==null&&q.suppressHydrationWarning===!0||c0(A.nodeValue,Z)?!0:!1,A||EZ(M,!0)}else A=M3(A).createTextNode(q),A[_A]=M,M.stateNode=A}return NA(M),null;case 31:if(Z=M.memoizedState,A===null||A.memoizedState!==null){if(q=Rq(M),Z!==null){if(A===null){if(!q)throw Error(w(318));if(A=M.memoizedState,A=A!==null?A.dehydrated:null,!A)throw Error(w(557));A[_A]=M}else rZ(),(M.flags&128)===0&&(M.memoizedState=null),M.flags|=4;NA(M),A=!1}else Z=iV(),A!==null&&A.memoizedState!==null&&(A.memoizedState.hydrationErrors=Z),A=!0;if(!A){if(M.flags&256)return LM(M),M;return LM(M),null}if((M.flags&128)!==0)throw Error(w(558))}return NA(M),null;case 13:if(q=M.memoizedState,A===null||A.memoizedState!==null&&A.memoizedState.dehydrated!==null){if(z=Rq(M),q!==null&&q.dehydrated!==null){if(A===null){if(!z)throw Error(w(318));if(z=M.memoizedState,z=z!==null?z.dehydrated:null,!z)throw Error(w(317));z[_A]=M}else rZ(),(M.flags&128)===0&&(M.memoizedState=null),M.flags|=4;NA(M),z=!1}else z=iV(),A!==null&&A.memoizedState!==null&&(A.memoizedState.hydrationErrors=z),z=!0;if(!z){if(M.flags&256)return LM(M),M;return LM(M),null}}if(LM(M),(M.flags&128)!==0)return M.lanes=Z,M;return Z=q!==null,A=A!==null&&A.memoizedState!==null,Z&&(q=M.child,z=null,q.alternate!==null&&q.alternate.memoizedState!==null&&q.alternate.memoizedState.cachePool!==null&&(z=q.alternate.memoizedState.cachePool.pool),Y=null,q.memoizedState!==null&&q.memoizedState.cachePool!==null&&(Y=q.memoizedState.cachePool.pool),Y!==z&&(q.flags|=2048)),Z!==A&&Z&&(M.child.flags|=8192),I9(M,M.updateQueue),NA(M),null;case 4:return sq(),A===null&&$Q(M.stateNode.containerInfo),NA(M),null;case 10:return u7(M.type),NA(M),null;case 19:if(sA(SA),q=M.memoizedState,q===null)return NA(M),null;if(z=(M.flags&128)!==0,Y=q.rendering,Y===null)if(z)fz(q,!1);else{if(bA!==0||A!==null&&(A.flags&128)!==0)for(A=M.child;A!==null;){if(Y=l9(A),Y!==null){M.flags|=128,fz(q,!1),A=Y.updateQueue,M.updateQueue=A,I9(M,A),M.subtreeFlags=0,A=Z;for(Z=M.child;Z!==null;)qI(Z,A),Z=Z.sibling;return TA(SA,SA.current&1|2),e&&x7(M,q.treeForkCount),M.child}A=A.sibling}q.tail!==null&&CM()>n9&&(M.flags|=128,z=!0,fz(q,!1),M.lanes=4194304)}else{if(!z)if(A=l9(Y),A!==null){if(M.flags|=128,z=!0,A=A.updateQueue,M.updateQueue=A,I9(M,A),fz(q,!0),q.tail===null&&q.tailMode==="hidden"&&!Y.alternate&&!e)return NA(M),null}else 2*CM()-q.renderingStartTime>n9&&Z!==536870912&&(M.flags|=128,z=!0,fz(q,!1),M.lanes=4194304);q.isBackwards?(Y.sibling=M.child,M.child=Y):(A=q.last,A!==null?A.sibling=Y:M.child=Y,q.last=Y)}if(q.tail!==null)return A=q.tail,q.rendering=A,q.tail=A.sibling,q.renderingStartTime=CM(),A.sibling=null,Z=SA.current,TA(SA,z?Z&1|2:Z&1),e&&x7(M,q.treeForkCount),A;return NA(M),null;case 22:case 23:return LM(M),CQ(),q=M.memoizedState!==null,A!==null?A.memoizedState!==null!==q&&(M.flags|=8192):q&&(M.flags|=8192),q?(Z&536870912)!==0&&(M.flags&128)===0&&(NA(M),M.subtreeFlags&6&&(M.flags|=8192)):NA(M),Z=M.updateQueue,Z!==null&&I9(M,Z.retryQueue),Z=null,A!==null&&A.memoizedState!==null&&A.memoizedState.cachePool!==null&&(Z=A.memoizedState.cachePool.pool),q=null,M.memoizedState!==null&&M.memoizedState.cachePool!==null&&(q=M.memoizedState.cachePool.pool),q!==Z&&(M.flags|=2048),A!==null&&sA(cZ),null;case 24:return Z=null,A!==null&&(Z=A.memoizedState.cache),M.memoizedState.cache!==Z&&(M.flags|=2048),u7(fA),NA(M),null;case 25:return null;case 30:return null}throw Error(w(156,M.tag))}function g5(A,M){switch(HQ(M),M.tag){case 1:return A=M.flags,A&65536?(M.flags=A&-65537|128,M):null;case 3:return u7(fA),sq(),A=M.flags,(A&65536)!==0&&(A&128)===0?(M.flags=A&-65537|128,M):null;case 26:case 27:case 5:return h9(M),null;case 31:if(M.memoizedState!==null){if(LM(M),M.alternate===null)throw Error(w(340));rZ()}return A=M.flags,A&65536?(M.flags=A&-65537|128,M):null;case 13:if(LM(M),A=M.memoizedState,A!==null&&A.dehydrated!==null){if(M.alternate===null)throw Error(w(340));rZ()}return A=M.flags,A&65536?(M.flags=A&-65537|128,M):null;case 19:return sA(SA),null;case 4:return sq(),null;case 10:return u7(M.type),null;case 22:case 23:return LM(M),CQ(),A!==null&&sA(cZ),A=M.flags,A&65536?(M.flags=A&-65537|128,M):null;case 24:return u7(fA),null;case 25:return null;default:return null}}function q0(A,M){switch(HQ(M),M.tag){case 3:u7(fA),sq();break;case 26:case 27:case 5:h9(M);break;case 4:sq();break;case 31:M.memoizedState!==null&&LM(M);break;case 13:LM(M);break;case 19:sA(SA);break;case 10:u7(M.type);break;case 22:case 23:LM(M),CQ(),A!==null&&sA(cZ);break;case 24:u7(fA)}}function bY(A,M){try{var Z=M.updateQueue,q=Z!==null?Z.lastEffect:null;if(q!==null){var z=q.next;Z=z;do{if((Z.tag&A)===A){q=void 0;var{create:Y,inst:V}=Z;q=Y(),V.destroy=q}Z=Z.next}while(Z!==z)}}catch(Q){UA(M,M.return,Q)}}function RZ(A,M,Z){try{var q=M.updateQueue,z=q!==null?q.lastEffect:null;if(z!==null){var Y=z.next;q=Y;do{if((q.tag&A)===A){var V=q.inst,Q=V.destroy;if(Q!==void 0){V.destroy=void 0,z=M;var U=Z,B=Q;try{B()}catch(W){UA(z,U,W)}}}q=q.next}while(q!==Y)}}catch(W){UA(M,M.return,W)}}function z0(A){var M=A.updateQueue;if(M!==null){var Z=A.stateNode;try{JI(M,Z)}catch(q){UA(A,A.return,q)}}}function Y0(A,M,Z){Z.props=nZ(A.type,A.memoizedProps),Z.state=A.memoizedState;try{Z.componentWillUnmount()}catch(q){UA(A,M,q)}}function ZY(A,M){try{var Z=A.ref;if(Z!==null){switch(A.tag){case 26:case 27:case 5:var q=A.stateNode;break;case 30:q=A.stateNode;break;default:q=A.stateNode}typeof Z==="function"?A.refCleanup=Z(q):Z.current=q}}catch(z){UA(A,M,z)}}function N7(A,M){var{ref:Z,refCleanup:q}=A;if(Z!==null)if(typeof q==="function")try{q()}catch(z){UA(A,M,z)}finally{A.refCleanup=null,A=A.alternate,A!=null&&(A.refCleanup=null)}else if(typeof Z==="function")try{Z(null)}catch(z){UA(A,M,z)}else Z.current=null}function V0(A){var{type:M,memoizedProps:Z,stateNode:q}=A;try{A:switch(M){case"button":case"input":case"select":case"textarea":Z.autoFocus&&q.focus();break A;case"img":Z.src?q.src=Z.src:Z.srcSet&&(q.srcset=Z.srcSet)}}catch(z){UA(A,A.return,z)}}function A2(A,M,Z){try{var q=A.stateNode;qD(q,A.type,Z,M),q[jM]=M}catch(z){UA(A,A.return,z)}}function Q0(A){return A.tag===5||A.tag===3||A.tag===26||A.tag===27&&LZ(A.type)||A.tag===4}function M2(A){A:for(;;){for(;A.sibling===null;){if(A.return===null||Q0(A.return))return null;A=A.return}A.sibling.return=A.return;for(A=A.sibling;A.tag!==5&&A.tag!==6&&A.tag!==18;){if(A.tag===27&&LZ(A.type))continue A;if(A.flags&2)continue A;if(A.child===null||A.tag===4)continue A;else A.child.return=A,A=A.child}if(!(A.flags&2))return A.stateNode}}function l2(A,M,Z){var q=A.tag;if(q===5||q===6)A=A.stateNode,M?(Z.nodeType===9?Z.body:Z.nodeName==="HTML"?Z.ownerDocument.body:Z).insertBefore(A,M):(M=Z.nodeType===9?Z.body:Z.nodeName==="HTML"?Z.ownerDocument.body:Z,M.appendChild(A),Z=Z._reactRootContainer,Z!==null&&Z!==void 0||M.onclick!==null||(M.onclick=v7));else if(q!==4&&(q===27&&LZ(A.type)&&(Z=A.stateNode,M=null),A=A.child,A!==null))for(l2(A,M,Z),A=A.sibling;A!==null;)l2(A,M,Z),A=A.sibling}function a9(A,M,Z){var q=A.tag;if(q===5||q===6)A=A.stateNode,M?Z.insertBefore(A,M):Z.appendChild(A);else if(q!==4&&(q===27&&LZ(A.type)&&(Z=A.stateNode),A=A.child,A!==null))for(a9(A,M,Z),A=A.sibling;A!==null;)a9(A,M,Z),A=A.sibling}function U0(A){var{stateNode:M,memoizedProps:Z}=A;try{for(var q=A.type,z=M.attributes;z.length;)M.removeAttributeNode(z[0]);AM(M,q,Z),M[_A]=A,M[jM]=Z}catch(Y){UA(A,A.return,Y)}}var y7=!1,vA=!1,Z2=!1,lB=typeof WeakSet==="function"?WeakSet:Set,iA=null;function u5(A,M){if(A=A.containerInfo,t2=Y3,A=nG(A),jQ(A)){if("selectionStart"in A)var Z={start:A.selectionStart,end:A.selectionEnd};else A:{Z=(Z=A.ownerDocument)&&Z.defaultView||window;var q=Z.getSelection&&Z.getSelection();if(q&&q.rangeCount!==0){Z=q.anchorNode;var{anchorOffset:z,focusNode:Y}=q;q=q.focusOffset;try{Z.nodeType,Y.nodeType}catch(O){Z=null;break A}var V=0,Q=-1,U=-1,B=0,W=0,J=A,I=null;M:for(;;){for(var K;;){if(J!==Z||z!==0&&J.nodeType!==3||(Q=V+z),J!==Y||q!==0&&J.nodeType!==3||(U=V+q),J.nodeType===3&&(V+=J.nodeValue.length),(K=J.firstChild)===null)break;I=J,J=K}for(;;){if(J===A)break M;if(I===Z&&++B===z&&(Q=V),I===Y&&++W===q&&(U=V),(K=J.nextSibling)!==null)break;J=I,I=J.parentNode}J=K}Z=Q===-1||U===-1?null:{start:Q,end:U}}else Z=null}Z=Z||{start:0,end:0}}else Z=null;e2={focusedElem:A,selectionRange:Z},Y3=!1;for(iA=M;iA!==null;)if(M=iA,A=M.child,(M.subtreeFlags&1028)!==0&&A!==null)A.return=M,iA=A;else for(;iA!==null;){switch(M=iA,Y=M.alternate,A=M.flags,M.tag){case 0:if((A&4)!==0&&(A=M.updateQueue,A=A!==null?A.events:null,A!==null))for(Z=0;Z<A.length;Z++)z=A[Z],z.ref.impl=z.nextImpl;break;case 11:case 15:break;case 1:if((A&1024)!==0&&Y!==null){A=void 0,Z=M,z=Y.memoizedProps,Y=Y.memoizedState,q=Z.stateNode;try{var N=nZ(Z.type,z);A=q.getSnapshotBeforeUpdate(N,Y),q.__reactInternalSnapshotBeforeUpdate=A}catch(O){UA(Z,Z.return,O)}}break;case 3:if((A&1024)!==0){if(A=M.stateNode.containerInfo,Z=A.nodeType,Z===9)MQ(A);else if(Z===1)switch(A.nodeName){case"HEAD":case"HTML":case"BODY":MQ(A);break;default:A.textContent=""}}break;case 5:case 26:case 27:case 6:case 4:case 17:break;default:if((A&1024)!==0)throw Error(w(163))}if(A=M.sibling,A!==null){A.return=M.return,iA=A;break}iA=M.return}}function B0(A,M,Z){var q=Z.flags;switch(Z.tag){case 0:case 11:case 15:S7(A,Z),q&4&&bY(5,Z);break;case 1:if(S7(A,Z),q&4)if(A=Z.stateNode,M===null)try{A.componentDidMount()}catch(V){UA(Z,Z.return,V)}else{var z=nZ(Z.type,M.memoizedProps);M=M.memoizedState;try{A.componentDidUpdate(z,M,A.__reactInternalSnapshotBeforeUpdate)}catch(V){UA(Z,Z.return,V)}}q&64&&z0(Z),q&512&&ZY(Z,Z.return);break;case 3:if(S7(A,Z),q&64&&(A=Z.updateQueue,A!==null)){if(M=null,Z.child!==null)switch(Z.child.tag){case 27:case 5:M=Z.child.stateNode;break;case 1:M=Z.child.stateNode}try{JI(A,M)}catch(V){UA(Z,Z.return,V)}}break;case 27:M===null&&q&4&&U0(Z);case 26:case 5:S7(A,Z),M===null&&q&4&&V0(Z),q&512&&ZY(Z,Z.return);break;case 12:S7(A,Z);break;case 31:S7(A,Z),q&4&&W0(A,Z);break;case 13:S7(A,Z),q&4&&J0(A,Z),q&64&&(A=Z.memoizedState,A!==null&&(A=A.dehydrated,A!==null&&(Z=o5.bind(null,Z),ID(A,Z))));break;case 22:if(q=Z.memoizedState!==null||y7,!q){M=M!==null&&M.memoizedState!==null||vA,z=y7;var Y=vA;y7=q,(vA=M)&&!Y?P7(A,Z,(Z.subtreeFlags&8772)!==0):S7(A,Z),y7=z,vA=Y}break;case 30:break;default:S7(A,Z)}}function G0(A){var M=A.alternate;M!==null&&(A.alternate=null,G0(M)),A.child=null,A.deletions=null,A.sibling=null,A.tag===5&&(M=A.stateNode,M!==null&&WQ(M)),A.stateNode=null,A.return=null,A.dependencies=null,A.memoizedProps=null,A.memoizedState=null,A.pendingProps=null,A.stateNode=null,A.updateQueue=null}var FA=null,KM=!1;function b7(A,M,Z){for(Z=Z.child;Z!==null;)I0(A,M,Z),Z=Z.sibling}function I0(A,M,Z){if(bM&&typeof bM.onCommitFiberUnmount==="function")try{bM.onCommitFiberUnmount(RY,Z)}catch(Y){}switch(Z.tag){case 26:vA||N7(Z,M),b7(A,M,Z),Z.memoizedState?Z.memoizedState.count--:Z.stateNode&&(Z=Z.stateNode,Z.parentNode.removeChild(Z));break;case 27:vA||N7(Z,M);var q=FA,z=KM;LZ(Z.type)&&(FA=Z.stateNode,KM=!1),b7(A,M,Z),VY(Z.stateNode),FA=q,KM=z;break;case 5:vA||N7(Z,M);case 6:if(q=FA,z=KM,FA=null,b7(A,M,Z),FA=q,KM=z,FA!==null)if(KM)try{(FA.nodeType===9?FA.body:FA.nodeName==="HTML"?FA.ownerDocument.body:FA).removeChild(Z.stateNode)}catch(Y){UA(Z,M,Y)}else try{FA.removeChild(Z.stateNode)}catch(Y){UA(Z,M,Y)}break;case 18:FA!==null&&(KM?(A=FA,ZG(A.nodeType===9?A.body:A.nodeName==="HTML"?A.ownerDocument.body:A,Z.stateNode),Zz(A)):ZG(FA,Z.stateNode));break;case 4:q=FA,z=KM,FA=Z.stateNode.containerInfo,KM=!0,b7(A,M,Z),FA=q,KM=z;break;case 0:case 11:case 14:case 15:RZ(2,Z,M),vA||RZ(4,Z,M),b7(A,M,Z);break;case 1:vA||(N7(Z,M),q=Z.stateNode,typeof q.componentWillUnmount==="function"&&Y0(Z,M,q)),b7(A,M,Z);break;case 21:b7(A,M,Z);break;case 22:vA=(q=vA)||Z.memoizedState!==null,b7(A,M,Z),vA=q;break;default:b7(A,M,Z)}}function W0(A,M){if(M.memoizedState===null&&(A=M.alternate,A!==null&&(A=A.memoizedState,A!==null))){A=A.dehydrated;try{Zz(A)}catch(Z){UA(M,M.return,Z)}}}function J0(A,M){if(M.memoizedState===null&&(A=M.alternate,A!==null&&(A=A.memoizedState,A!==null&&(A=A.dehydrated,A!==null))))try{Zz(A)}catch(Z){UA(M,M.return,Z)}}function m5(A){switch(A.tag){case 31:case 13:case 19:var M=A.stateNode;return M===null&&(M=A.stateNode=new lB),M;case 22:return A=A.stateNode,M=A._retryCache,M===null&&(M=A._retryCache=new lB),M;default:throw Error(w(435,A.tag))}}function W9(A,M){var Z=m5(A);M.forEach(function(q){if(!Z.has(q)){Z.add(q);var z=a5.bind(null,A,q);q.then(z,z)}})}function JM(A,M){var Z=M.deletions;if(Z!==null)for(var q=0;q<Z.length;q++){var z=Z[q],Y=A,V=M,Q=V;A:for(;Q!==null;){switch(Q.tag){case 27:if(LZ(Q.type)){FA=Q.stateNode,KM=!1;break A}break;case 5:FA=Q.stateNode,KM=!1;break A;case 3:case 4:FA=Q.stateNode.containerInfo,KM=!0;break A}Q=Q.return}if(FA===null)throw Error(w(160));I0(Y,V,z),FA=null,KM=!1,Y=z.alternate,Y!==null&&(Y.return=null),z.return=null}if(M.subtreeFlags&13886)for(M=M.child;M!==null;)T0(M,A),M=M.sibling}var M7=null;function T0(A,M){var{alternate:Z,flags:q}=A;switch(A.tag){case 0:case 11:case 14:case 15:JM(M,A),TM(A),q&4&&(RZ(3,A,A.return),bY(3,A),RZ(5,A,A.return));break;case 1:JM(M,A),TM(A),q&512&&(vA||Z===null||N7(Z,Z.return)),q&64&&y7&&(A=A.updateQueue,A!==null&&(q=A.callbacks,q!==null&&(Z=A.shared.hiddenCallbacks,A.shared.hiddenCallbacks=Z===null?q:Z.concat(q))));break;case 26:var z=M7;if(JM(M,A),TM(A),q&512&&(vA||Z===null||N7(Z,Z.return)),q&4){var Y=Z!==null?Z.memoizedState:null;if(q=A.memoizedState,Z===null)if(q===null)if(A.stateNode===null){A:{q=A.type,Z=A.memoizedProps,z=z.ownerDocument||z;M:switch(q){case"title":if(Y=z.getElementsByTagName("title")[0],!Y||Y[LY]||Y[_A]||Y.namespaceURI==="http://www.w3.org/2000/svg"||Y.hasAttribute("itemprop"))Y=z.createElement(q),z.head.insertBefore(Y,z.querySelector("head > title"));AM(Y,q,Z),Y[_A]=A,rA(Y),q=Y;break A;case"link":var V=BG("link","href",z).get(q+(Z.href||""));if(V){for(var Q=0;Q<V.length;Q++)if(Y=V[Q],Y.getAttribute("href")===(Z.href==null||Z.href===""?null:Z.href)&&Y.getAttribute("rel")===(Z.rel==null?null:Z.rel)&&Y.getAttribute("title")===(Z.title==null?null:Z.title)&&Y.getAttribute("crossorigin")===(Z.crossOrigin==null?null:Z.crossOrigin)){V.splice(Q,1);break M}}Y=z.createElement(q),AM(Y,q,Z),z.head.appendChild(Y);break;case"meta":if(V=BG("meta","content",z).get(q+(Z.content||""))){for(Q=0;Q<V.length;Q++)if(Y=V[Q],Y.getAttribute("content")===(Z.content==null?null:""+Z.content)&&Y.getAttribute("name")===(Z.name==null?null:Z.name)&&Y.getAttribute("property")===(Z.property==null?null:Z.property)&&Y.getAttribute("http-equiv")===(Z.httpEquiv==null?null:Z.httpEquiv)&&Y.getAttribute("charset")===(Z.charSet==null?null:Z.charSet)){V.splice(Q,1);break M}}Y=z.createElement(q),AM(Y,q,Z),z.head.appendChild(Y);break;default:throw Error(w(468,q))}Y[_A]=A,rA(Y),q=Y}A.stateNode=q}else GG(z,A.type,A.stateNode);else A.stateNode=UG(z,q,A.memoizedProps);else Y!==q?(Y===null?Z.stateNode!==null&&(Z=Z.stateNode,Z.parentNode.removeChild(Z)):Y.count--,q===null?GG(z,A.type,A.stateNode):UG(z,q,A.memoizedProps)):q===null&&A.stateNode!==null&&A2(A,A.memoizedProps,Z.memoizedProps)}break;case 27:JM(M,A),TM(A),q&512&&(vA||Z===null||N7(Z,Z.return)),Z!==null&&q&4&&A2(A,A.memoizedProps,Z.memoizedProps);break;case 5:if(JM(M,A),TM(A),q&512&&(vA||Z===null||N7(Z,Z.return)),A.flags&32){z=A.stateNode;try{aq(z,"")}catch(N){UA(A,A.return,N)}}q&4&&A.stateNode!=null&&(z=A.memoizedProps,A2(A,z,Z!==null?Z.memoizedProps:z)),q&1024&&(Z2=!0);break;case 6:if(JM(M,A),TM(A),q&4){if(A.stateNode===null)throw Error(w(162));q=A.memoizedProps,Z=A.stateNode;try{Z.nodeValue=q}catch(N){UA(A,A.return,N)}}break;case 3:if(b9=null,z=M7,M7=Z3(M.containerInfo),JM(M,A),M7=z,TM(A),q&4&&Z!==null&&Z.memoizedState.isDehydrated)try{Zz(M.containerInfo)}catch(N){UA(A,A.return,N)}Z2&&(Z2=!1,K0(A));break;case 4:q=M7,M7=Z3(A.stateNode.containerInfo),JM(M,A),TM(A),M7=q;break;case 12:JM(M,A),TM(A);break;case 31:JM(M,A),TM(A),q&4&&(q=A.updateQueue,q!==null&&(A.updateQueue=null,W9(A,q)));break;case 13:JM(M,A),TM(A),A.child.flags&8192&&A.memoizedState!==null!==(Z!==null&&Z.memoizedState!==null)&&(j3=CM()),q&4&&(q=A.updateQueue,q!==null&&(A.updateQueue=null,W9(A,q)));break;case 22:z=A.memoizedState!==null;var U=Z!==null&&Z.memoizedState!==null,B=y7,W=vA;if(y7=B||z,vA=W||U,JM(M,A),vA=W,y7=B,TM(A),q&8192)A:for(M=A.stateNode,M._visibility=z?M._visibility&-2:M._visibility|1,z&&(Z===null||U||y7||vA||mZ(A)),Z=null,M=A;;){if(M.tag===5||M.tag===26){if(Z===null){U=Z=M;try{if(Y=U.stateNode,z)V=Y.style,typeof V.setProperty==="function"?V.setProperty("display","none","important"):V.display="none";else{Q=U.stateNode;var J=U.memoizedProps.style,I=J!==void 0&&J!==null&&J.hasOwnProperty("display")?J.display:null;Q.style.display=I==null||typeof I==="boolean"?"":(""+I).trim()}}catch(N){UA(U,U.return,N)}}}else if(M.tag===6){if(Z===null){U=M;try{U.stateNode.nodeValue=z?"":U.memoizedProps}catch(N){UA(U,U.return,N)}}}else if(M.tag===18){if(Z===null){U=M;try{var K=U.stateNode;z?qG(K,!0):qG(U.stateNode,!1)}catch(N){UA(U,U.return,N)}}}else if((M.tag!==22&&M.tag!==23||M.memoizedState===null||M===A)&&M.child!==null){M.child.return=M,M=M.child;continue}if(M===A)break A;for(;M.sibling===null;){if(M.return===null||M.return===A)break A;Z===M&&(Z=null),M=M.return}Z===M&&(Z=null),M.sibling.return=M.return,M=M.sibling}q&4&&(q=A.updateQueue,q!==null&&(Z=q.retryQueue,Z!==null&&(q.retryQueue=null,W9(A,Z))));break;case 19:JM(M,A),TM(A),q&4&&(q=A.updateQueue,q!==null&&(A.updateQueue=null,W9(A,q)));break;case 30:break;case 21:break;default:JM(M,A),TM(A)}}function TM(A){var M=A.flags;if(M&2){try{for(var Z,q=A.return;q!==null;){if(Q0(q)){Z=q;break}q=q.return}if(Z==null)throw Error(w(160));switch(Z.tag){case 27:var z=Z.stateNode,Y=M2(A);a9(A,Y,z);break;case 5:var V=Z.stateNode;Z.flags&32&&(aq(V,""),Z.flags&=-33);var Q=M2(A);a9(A,Q,V);break;case 3:case 4:var U=Z.stateNode.containerInfo,B=M2(A);l2(A,B,U);break;default:throw Error(w(161))}}catch(W){UA(A,A.return,W)}A.flags&=-3}M&4096&&(A.flags&=-4097)}function K0(A){if(A.subtreeFlags&1024)for(A=A.child;A!==null;){var M=A;K0(M),M.tag===5&&M.flags&1024&&M.stateNode.reset(),A=A.sibling}}function S7(A,M){if(M.subtreeFlags&8772)for(M=M.child;M!==null;)B0(A,M.alternate,M),M=M.sibling}function mZ(A){for(A=A.child;A!==null;){var M=A;switch(M.tag){case 0:case 11:case 14:case 15:RZ(4,M,M.return),mZ(M);break;case 1:N7(M,M.return);var Z=M.stateNode;typeof Z.componentWillUnmount==="function"&&Y0(M,M.return,Z),mZ(M);break;case 27:VY(M.stateNode);case 26:case 5:N7(M,M.return),mZ(M);break;case 22:M.memoizedState===null&&mZ(M);break;case 30:mZ(M);break;default:mZ(M)}A=A.sibling}}function P7(A,M,Z){Z=Z&&(M.subtreeFlags&8772)!==0;for(M=M.child;M!==null;){var q=M.alternate,z=A,Y=M,V=Y.flags;switch(Y.tag){case 0:case 11:case 15:P7(z,Y,Z),bY(4,Y);break;case 1:if(P7(z,Y,Z),q=Y,z=q.stateNode,typeof z.componentDidMount==="function")try{z.componentDidMount()}catch(B){UA(q,q.return,B)}if(q=Y,z=q.updateQueue,z!==null){var Q=q.stateNode;try{var U=z.shared.hiddenCallbacks;if(U!==null)for(z.shared.hiddenCallbacks=null,z=0;z<U.length;z++)WI(U[z],Q)}catch(B){UA(q,q.return,B)}}Z&&V&64&&z0(Y),ZY(Y,Y.return);break;case 27:U0(Y);case 26:case 5:P7(z,Y,Z),Z&&q===null&&V&4&&V0(Y),ZY(Y,Y.return);break;case 12:P7(z,Y,Z);break;case 31:P7(z,Y,Z),Z&&V&4&&W0(z,Y);break;case 13:P7(z,Y,Z),Z&&V&4&&J0(z,Y);break;case 22:Y.memoizedState===null&&P7(z,Y,Z),ZY(Y,Y.return);break;case 30:break;default:P7(z,Y,Z)}M=M.sibling}}function iQ(A,M){var Z=null;A!==null&&A.memoizedState!==null&&A.memoizedState.cachePool!==null&&(Z=A.memoizedState.cachePool.pool),A=null,M.memoizedState!==null&&M.memoizedState.cachePool!==null&&(A=M.memoizedState.cachePool.pool),A!==Z&&(A!=null&&A.refCount++,Z!=null&&kY(Z))}function rQ(A,M){A=null,M.alternate!==null&&(A=M.alternate.memoizedState.cache),M=M.memoizedState.cache,M!==A&&(M.refCount++,A!=null&&kY(A))}function A7(A,M,Z,q){if(M.subtreeFlags&10256)for(M=M.child;M!==null;)D0(A,M,Z,q),M=M.sibling}function D0(A,M,Z,q){var z=M.flags;switch(M.tag){case 0:case 11:case 15:A7(A,M,Z,q),z&2048&&bY(9,M);break;case 1:A7(A,M,Z,q);break;case 3:A7(A,M,Z,q),z&2048&&(A=null,M.alternate!==null&&(A=M.alternate.memoizedState.cache),M=M.memoizedState.cache,M!==A&&(M.refCount++,A!=null&&kY(A)));break;case 12:if(z&2048){A7(A,M,Z,q),A=M.stateNode;try{var Y=M.memoizedProps,V=Y.id,Q=Y.onPostCommit;typeof Q==="function"&&Q(V,M.alternate===null?"mount":"update",A.passiveEffectDuration,-0)}catch(U){UA(M,M.return,U)}}else A7(A,M,Z,q);break;case 31:A7(A,M,Z,q);break;case 13:A7(A,M,Z,q);break;case 23:break;case 22:Y=M.stateNode,V=M.alternate,M.memoizedState!==null?Y._visibility&2?A7(A,M,Z,q):qY(A,M):Y._visibility&2?A7(A,M,Z,q):(Y._visibility|=2,Fq(A,M,Z,q,(M.subtreeFlags&10256)!==0||!1)),z&2048&&iQ(V,M);break;case 24:A7(A,M,Z,q),z&2048&&rQ(M.alternate,M);break;default:A7(A,M,Z,q)}}function Fq(A,M,Z,q,z){z=z&&((M.subtreeFlags&10256)!==0||!1);for(M=M.child;M!==null;){var Y=A,V=M,Q=Z,U=q,B=V.flags;switch(V.tag){case 0:case 11:case 15:Fq(Y,V,Q,U,z),bY(8,V);break;case 23:break;case 22:var W=V.stateNode;V.memoizedState!==null?W._visibility&2?Fq(Y,V,Q,U,z):qY(Y,V):(W._visibility|=2,Fq(Y,V,Q,U,z)),z&&B&2048&&iQ(V.alternate,V);break;case 24:Fq(Y,V,Q,U,z),z&&B&2048&&rQ(V.alternate,V);break;default:Fq(Y,V,Q,U,z)}M=M.sibling}}function qY(A,M){if(M.subtreeFlags&10256)for(M=M.child;M!==null;){var Z=A,q=M,z=q.flags;switch(q.tag){case 22:qY(Z,q),z&2048&&iQ(q.alternate,q);break;case 24:qY(Z,q),z&2048&&rQ(q.alternate,q);break;default:qY(Z,q)}M=M.sibling}}var rz=8192;function Hq(A,M,Z){if(A.subtreeFlags&rz)for(A=A.child;A!==null;)N0(A,M,Z),A=A.sibling}function N0(A,M,Z){switch(A.tag){case 26:Hq(A,M,Z),A.flags&rz&&A.memoizedState!==null&&HD(Z,M7,A.memoizedState,A.memoizedProps);break;case 5:Hq(A,M,Z);break;case 3:case 4:var q=M7;M7=Z3(A.stateNode.containerInfo),Hq(A,M,Z),M7=q;break;case 22:A.memoizedState===null&&(q=A.alternate,q!==null&&q.memoizedState!==null?(q=rz,rz=16777216,Hq(A,M,Z),rz=q):Hq(A,M,Z));break;default:Hq(A,M,Z)}}function j0(A){var M=A.alternate;if(M!==null&&(A=M.child,A!==null)){M.child=null;do M=A.sibling,A.sibling=null,A=M;while(A!==null)}}function gz(A){var M=A.deletions;if((A.flags&16)!==0){if(M!==null)for(var Z=0;Z<M.length;Z++){var q=M[Z];iA=q,O0(q,A)}j0(A)}if(A.subtreeFlags&10256)for(A=A.child;A!==null;)X0(A),A=A.sibling}function X0(A){switch(A.tag){case 0:case 11:case 15:gz(A),A.flags&2048&&RZ(9,A,A.return);break;case 3:gz(A);break;case 12:gz(A);break;case 22:var M=A.stateNode;A.memoizedState!==null&&M._visibility&2&&(A.return===null||A.return.tag!==13)?(M._visibility&=-3,k9(A)):gz(A);break;default:gz(A)}}function k9(A){var M=A.deletions;if((A.flags&16)!==0){if(M!==null)for(var Z=0;Z<M.length;Z++){var q=M[Z];iA=q,O0(q,A)}j0(A)}for(A=A.child;A!==null;){switch(M=A,M.tag){case 0:case 11:case 15:RZ(8,M,M.return),k9(M);break;case 22:Z=M.stateNode,Z._visibility&2&&(Z._visibility&=-3,k9(M));break;default:k9(M)}A=A.sibling}}function O0(A,M){for(;iA!==null;){var Z=iA;switch(Z.tag){case 0:case 11:case 15:RZ(8,Z,M);break;case 23:case 22:if(Z.memoizedState!==null&&Z.memoizedState.cachePool!==null){var q=Z.memoizedState.cachePool.pool;q!=null&&q.refCount++}break;case 24:kY(Z.memoizedState.cache)}if(q=Z.child,q!==null)q.return=Z,iA=q;else A:for(Z=A;iA!==null;){q=iA;var{sibling:z,return:Y}=q;if(G0(q),q===Z){iA=null;break A}if(z!==null){z.return=Y,iA=z;break A}iA=Y}}}var d5={getCacheForType:function(A){var M=eA(fA),Z=M.data.get(A);return Z===void 0&&(Z=A(),M.data.set(A,Z)),Z},cacheSignal:function(){return eA(fA).controller.signal}},p5=typeof WeakMap==="function"?WeakMap:Map,qA=0,JA=null,_=null,t=0,QA=0,FM=null,UZ=!1,Qz=!1,sQ=!1,i7=0,bA=0,HZ=0,iZ=0,oQ=0,kM=0,tq=0,zY=null,DM=null,i2=!1,j3=0,E0=0,n9=1/0,$9=null,KZ=null,pA=0,DZ=null,eq=null,m7=0,r2=0,s2=null,R0=null,YY=0,o2=null;function PM(){return(qA&2)!==0&&t!==0?t&-t:f.T!==null?nQ():PG()}function H0(){if(kM===0)if((t&536870912)===0||e){var A=z9;z9<<=1,(z9&3932160)===0&&(z9=262144),kM=A}else kM=536870912;return A=yM.current,A!==null&&(A.flags|=32),kM}function NM(A,M,Z){if(A===JA&&(QA===2||QA===9)||A.cancelPendingCommit!==null)Az(A,0),BZ(A,t,kM,!1);if(FY(A,Z),(qA&2)===0||A!==JA)A===JA&&((qA&2)===0&&(iZ|=Z),bA===4&&BZ(A,t,kM,!1)),O7(A)}function F0(A,M,Z){if((qA&6)!==0)throw Error(w(327));var q=!Z&&(M&127)===0&&(M&A.expiredLanes)===0||HY(A,M),z=q?i5(A,M):q2(A,M,!0),Y=q;do{if(z===0){Qz&&!q&&BZ(A,M,0,!1);break}else{if(Z=A.current.alternate,Y&&!c5(Z)){z=q2(A,M,!1),Y=!1;continue}if(z===2){if(Y=M,A.errorRecoveryDisabledLanes&Y)var V=0;else V=A.pendingLanes&-536870913,V=V!==0?V:V&536870912?536870912:0;if(V!==0){M=V;A:{var Q=A;z=zY;var U=Q.current.memoizedState.isDehydrated;if(U&&(Az(Q,V).flags|=256),V=q2(Q,V,!1),V!==2){if(sQ&&!U){Q.errorRecoveryDisabledLanes|=Y,iZ|=Y,z=4;break A}Y=DM,DM=z,Y!==null&&(DM===null?DM=Y:DM.push.apply(DM,Y))}z=V}if(Y=!1,z!==2)continue}}if(z===1){Az(A,0),BZ(A,M,0,!0);break}A:{switch(q=A,Y=z,Y){case 0:case 1:throw Error(w(345));case 4:if((M&4194048)!==M)break;case 6:BZ(q,M,kM,!UZ);break A;case 2:DM=null;break;case 3:case 5:break;default:throw Error(w(329))}if((M&62914560)===M&&(z=j3+300-CM(),10<z)){if(BZ(q,M,kM,!UZ),Q3(q,0,!0)!==0)break A;m7=M,q.timeoutHandle=i0(iB.bind(null,q,Z,DM,$9,i2,M,kM,iZ,tq,UZ,Y,"Throttled",-0,0),z);break A}iB(q,Z,DM,$9,i2,M,kM,iZ,tq,UZ,Y,null,-0,0)}}break}while(1);O7(A)}function iB(A,M,Z,q,z,Y,V,Q,U,B,W,J,I,K){if(A.timeoutHandle=-1,J=M.subtreeFlags,J&8192||(J&16785408)===16785408){J={stylesheets:null,count:0,imgCount:0,imgBytes:0,suspenseyImages:[],waitingForImages:!0,waitingForViewTransition:!1,unsuspend:v7},N0(M,Y,J);var N=(Y&62914560)===Y?j3-CM():(Y&4194048)===Y?E0-CM():0;if(N=FD(J,N),N!==null){m7=Y,A.cancelPendingCommit=N(sB.bind(null,A,M,Y,Z,q,z,V,Q,U,W,J,null,I,K)),BZ(A,Y,V,!B);return}}sB(A,M,Y,Z,q,z,V,Q,U)}function c5(A){for(var M=A;;){var Z=M.tag;if((Z===0||Z===11||Z===15)&&M.flags&16384&&(Z=M.updateQueue,Z!==null&&(Z=Z.stores,Z!==null)))for(var q=0;q<Z.length;q++){var z=Z[q],Y=z.getSnapshot;z=z.value;try{if(!xM(Y(),z))return!1}catch(V){return!1}}if(Z=M.child,M.subtreeFlags&16384&&Z!==null)Z.return=M,M=Z;else{if(M===A)break;for(;M.sibling===null;){if(M.return===null||M.return===A)return!0;M=M.return}M.sibling.return=M.return,M=M.sibling}}return!0}function BZ(A,M,Z,q){M&=~oQ,M&=~iZ,A.suspendedLanes|=M,A.pingedLanes&=~M,q&&(A.warmLanes|=M),q=A.expirationTimes;for(var z=M;0<z;){var Y=31-SM(z),V=1<<Y;q[Y]=-1,z&=~V}Z!==0&&CG(A,Z,M)}function X3(){return(qA&6)===0?(SY(0,!1),!1):!0}function aQ(){if(_!==null){if(QA===0)var A=_.return;else A=_,f7=Aq=null,yQ(A),lq=null,JY=0,A=_;for(;A!==null;)q0(A.alternate,A),A=A.return;_=null}}function Az(A,M){var Z=A.timeoutHandle;Z!==-1&&(A.timeoutHandle=-1,VD(Z)),Z=A.cancelPendingCommit,Z!==null&&(A.cancelPendingCommit=null,Z()),m7=0,aQ(),JA=A,_=Z=g7(A.current,null),t=M,QA=0,FM=null,UZ=!1,Qz=HY(A,M),sQ=!1,tq=kM=oQ=iZ=HZ=bA=0,DM=zY=null,i2=!1,(M&8)!==0&&(M|=M&32);var q=A.entangledLanes;if(q!==0)for(A=A.entanglements,q&=M;0<q;){var z=31-SM(q),Y=1<<z;M|=A[z],q&=~Y}return i7=M,I3(),Z}function L0(A,M){s=null,f.H=KY,M===Vz||M===J3?(M=RB(),QA=3):M===wQ?(M=RB(),QA=4):QA=M===cQ?8:M!==null&&typeof M==="object"&&typeof M.then==="function"?6:1,FM=M,_===null&&(bA=1,s9(A,iM(M,A.current)))}function w0(){var A=yM.current;return A===null?!0:(t&4194048)===t?sM===null?!0:!1:(t&62914560)===t||(t&536870912)!==0?A===sM:!1}function k0(){var A=f.H;return f.H=KY,A===null?KY:A}function C0(){var A=f.A;return f.A=d5,A}function _9(){bA=4,UZ||(t&4194048)!==t&&yM.current!==null||(Qz=!0),(HZ&134217727)===0&&(iZ&134217727)===0||JA===null||BZ(JA,t,kM,!1)}function q2(A,M,Z){var q=qA;qA|=2;var z=k0(),Y=C0();if(JA!==A||t!==M)$9=null,Az(A,M);M=!1;var V=bA;A:do try{if(QA!==0&&_!==null){var Q=_,U=FM;switch(QA){case 8:aQ(),V=6;break A;case 3:case 2:case 9:case 6:yM.current===null&&(M=!0);var B=QA;if(QA=0,FM=null,uq(A,Q,U,B),Z&&Qz){V=0;break A}break;default:B=QA,QA=0,FM=null,uq(A,Q,U,B)}}l5(),V=bA;break}catch(W){L0(A,W)}while(1);return M&&A.shellSuspendCounter++,f7=Aq=null,qA=q,f.H=z,f.A=Y,_===null&&(JA=null,t=0,I3()),V}function l5(){for(;_!==null;)b0(_)}function i5(A,M){var Z=qA;qA|=2;var q=k0(),z=C0();JA!==A||t!==M?($9=null,n9=CM()+500,Az(A,M)):Qz=HY(A,M);A:do try{if(QA!==0&&_!==null){M=_;var Y=FM;M:switch(QA){case 1:QA=0,FM=null,uq(A,M,Y,1);break;case 2:case 9:if(EB(Y)){QA=0,FM=null,rB(M);break}M=function(){QA!==2&&QA!==9||JA!==A||(QA=7),O7(A)},Y.then(M,M);break A;case 3:QA=7;break A;case 4:QA=5;break A;case 7:EB(Y)?(QA=0,FM=null,rB(M)):(QA=0,FM=null,uq(A,M,Y,7));break;case 5:var V=null;switch(_.tag){case 26:V=_.memoizedState;case 5:case 27:var Q=_;if(V?n0(V):Q.stateNode.complete){QA=0,FM=null;var U=Q.sibling;if(U!==null)_=U;else{var B=Q.return;B!==null?(_=B,O3(B)):_=null}break M}}QA=0,FM=null,uq(A,M,Y,5);break;case 6:QA=0,FM=null,uq(A,M,Y,6);break;case 8:aQ(),bA=6;break A;default:throw Error(w(462))}}r5();break}catch(W){L0(A,W)}while(1);if(f7=Aq=null,f.H=q,f.A=z,qA=Z,_!==null)return 0;return JA=null,t=0,I3(),bA}function r5(){for(;_!==null&&!TK();)b0(_)}function b0(A){var M=Z0(A.alternate,A,i7);A.memoizedProps=A.pendingProps,M===null?O3(A):_=M}function rB(A){var M=A,Z=M.alternate;switch(M.tag){case 15:case 0:M=uB(Z,M,M.pendingProps,M.type,void 0,t);break;case 11:M=uB(Z,M,M.pendingProps,M.type.render,M.ref,t);break;case 5:yQ(M);default:q0(Z,M),M=_=qI(M,i7),M=Z0(Z,M,i7)}A.memoizedProps=A.pendingProps,M===null?O3(A):_=M}function uq(A,M,Z,q){f7=Aq=null,yQ(M),lq=null,JY=0;var z=M.return;try{if(y5(A,z,M,Z,t)){bA=1,s9(A,iM(Z,A.current)),_=null;return}}catch(Y){if(z!==null)throw _=z,Y;bA=1,s9(A,iM(Z,A.current)),_=null;return}if(M.flags&32768){if(e||q===1)A=!0;else if(Qz||(t&536870912)!==0)A=!1;else if(UZ=A=!0,q===2||q===9||q===3||q===6)q=yM.current,q!==null&&q.tag===13&&(q.flags|=16384);S0(M,A)}else O3(M)}function O3(A){var M=A;do{if((M.flags&32768)!==0){S0(M,UZ);return}A=M.return;var Z=f5(M.alternate,M,i7);if(Z!==null){_=Z;return}if(M=M.sibling,M!==null){_=M;return}_=M=A}while(M!==null);bA===0&&(bA=5)}function S0(A,M){do{var Z=g5(A.alternate,A);if(Z!==null){Z.flags&=32767,_=Z;return}if(Z=A.return,Z!==null&&(Z.flags|=32768,Z.subtreeFlags=0,Z.deletions=null),!M&&(A=A.sibling,A!==null)){_=A;return}_=A=Z}while(A!==null);bA=6,_=null}function sB(A,M,Z,q,z,Y,V,Q,U){A.cancelPendingCommit=null;do E3();while(pA!==0);if((qA&6)!==0)throw Error(w(327));if(M!==null){if(M===A.current)throw Error(w(177));if(Y=M.lanes|M.childLanes,Y|=XQ,FK(A,Z,Y,V,Q,U),A===JA&&(_=JA=null,t=0),eq=M,DZ=A,m7=Z,r2=Y,s2=z,R0=q,(M.subtreeFlags&10256)!==0||(M.flags&10256)!==0?(A.callbackNode=null,A.callbackPriority=0,n5(v9,function(){return v0(),null})):(A.callbackNode=null,A.callbackPriority=0),q=(M.flags&13878)!==0,(M.subtreeFlags&13878)!==0||q){q=f.T,f.T=null,z=zA.p,zA.p=2,V=qA,qA|=4;try{u5(A,M,Z)}finally{qA=V,zA.p=z,f.T=q}}pA=1,P0(),x0(),y0()}}function P0(){if(pA===1){pA=0;var A=DZ,M=eq,Z=(M.flags&13878)!==0;if((M.subtreeFlags&13878)!==0||Z){Z=f.T,f.T=null;var q=zA.p;zA.p=2;var z=qA;qA|=4;try{T0(M,A);var Y=e2,V=nG(A.containerInfo),Q=Y.focusedElem,U=Y.selectionRange;if(V!==Q&&Q&&Q.ownerDocument&&aG(Q.ownerDocument.documentElement,Q)){if(U!==null&&jQ(Q)){var{start:B,end:W}=U;if(W===void 0&&(W=B),"selectionStart"in Q)Q.selectionStart=B,Q.selectionEnd=Math.min(W,Q.value.length);else{var J=Q.ownerDocument||document,I=J&&J.defaultView||window;if(I.getSelection){var K=I.getSelection(),N=Q.textContent.length,O=Math.min(U.start,N),j=U.end===void 0?O:Math.min(U.end,N);!K.extend&&O>j&&(V=j,j=O,O=V);var T=TB(Q,O),G=TB(Q,j);if(T&&G&&(K.rangeCount!==1||K.anchorNode!==T.node||K.anchorOffset!==T.offset||K.focusNode!==G.node||K.focusOffset!==G.offset)){var D=J.createRange();D.setStart(T.node,T.offset),K.removeAllRanges(),O>j?(K.addRange(D),K.extend(G.node,G.offset)):(D.setEnd(G.node,G.offset),K.addRange(D))}}}}J=[];for(K=Q;K=K.parentNode;)K.nodeType===1&&J.push({element:K,left:K.scrollLeft,top:K.scrollTop});typeof Q.focus==="function"&&Q.focus();for(Q=0;Q<J.length;Q++){var X=J[Q];X.element.scrollLeft=X.left,X.element.scrollTop=X.top}}Y3=!!t2,e2=t2=null}finally{qA=z,zA.p=q,f.T=Z}}A.current=M,pA=2}}function x0(){if(pA===2){pA=0;var A=DZ,M=eq,Z=(M.flags&8772)!==0;if((M.subtreeFlags&8772)!==0||Z){Z=f.T,f.T=null;var q=zA.p;zA.p=2;var z=qA;qA|=4;try{B0(A,M.alternate,M)}finally{qA=z,zA.p=q,f.T=Z}}pA=3}}function y0(){if(pA===4||pA===3){pA=0,KK();var A=DZ,M=eq,Z=m7,q=R0;(M.subtreeFlags&10256)!==0||(M.flags&10256)!==0?pA=5:(pA=0,eq=DZ=null,h0(A,A.pendingLanes));var z=A.pendingLanes;if(z===0&&(KZ=null),IQ(Z),M=M.stateNode,bM&&typeof bM.onCommitFiberRoot==="function")try{bM.onCommitFiberRoot(RY,M,void 0,(M.current.flags&128)===128)}catch(U){}if(q!==null){M=f.T,z=zA.p,zA.p=2,f.T=null;try{for(var Y=A.onRecoverableError,V=0;V<q.length;V++){var Q=q[V];Y(Q.value,{componentStack:Q.stack})}}finally{f.T=M,zA.p=z}}(m7&3)!==0&&E3(),O7(A),z=A.pendingLanes,(Z&261930)!==0&&(z&42)!==0?A===o2?YY++:(YY=0,o2=A):YY=0,SY(0,!1)}}function h0(A,M){(A.pooledCacheLanes&=M)===0&&(M=A.pooledCache,M!=null&&(A.pooledCache=null,kY(M)))}function E3(){return P0(),x0(),y0(),v0()}function v0(){if(pA!==5)return!1;var A=DZ,M=r2;r2=0;var Z=IQ(m7),q=f.T,z=zA.p;try{zA.p=32>Z?32:Z,f.T=null,Z=s2,s2=null;var Y=DZ,V=m7;if(pA=0,eq=DZ=null,m7=0,(qA&6)!==0)throw Error(w(331));var Q=qA;if(qA|=4,X0(Y.current),D0(Y,Y.current,V,Z),qA=Q,SY(0,!1),bM&&typeof bM.onPostCommitFiberRoot==="function")try{bM.onPostCommitFiberRoot(RY,Y)}catch(U){}return!0}finally{zA.p=z,f.T=q,h0(A,M)}}function oB(A,M,Z){M=iM(Z,M),M=d2(A.stateNode,M,2),A=TZ(A,M,2),A!==null&&(FY(A,2),O7(A))}function UA(A,M,Z){if(A.tag===3)oB(A,A,Z);else for(;M!==null;){if(M.tag===3){oB(M,A,Z);break}else if(M.tag===1){var q=M.stateNode;if(typeof M.type.getDerivedStateFromError==="function"||typeof q.componentDidCatch==="function"&&(KZ===null||!KZ.has(q))){A=iM(Z,A),Z=$I(2),q=TZ(M,Z,2),q!==null&&(_I(Z,q,M,A),FY(q,2),O7(q));break}}M=M.return}}function z2(A,M,Z){var q=A.pingCache;if(q===null){q=A.pingCache=new p5;var z=new Set;q.set(M,z)}else z=q.get(M),z===void 0&&(z=new Set,q.set(M,z));z.has(Z)||(sQ=!0,z.add(Z),A=s5.bind(null,A,M,Z),M.then(A,A))}function s5(A,M,Z){var q=A.pingCache;q!==null&&q.delete(M),A.pingedLanes|=A.suspendedLanes&Z,A.warmLanes&=~Z,JA===A&&(t&Z)===Z&&(bA===4||bA===3&&(t&62914560)===t&&300>CM()-j3?(qA&2)===0&&Az(A,0):oQ|=Z,tq===t&&(tq=0)),O7(A)}function f0(A,M){M===0&&(M=kG()),A=eZ(A,M),A!==null&&(FY(A,M),O7(A))}function o5(A){var M=A.memoizedState,Z=0;M!==null&&(Z=M.retryLane),f0(A,Z)}function a5(A,M){var Z=0;switch(A.tag){case 31:case 13:var{stateNode:q,memoizedState:z}=A;z!==null&&(Z=z.retryLane);break;case 19:q=A.stateNode;break;case 22:q=A.stateNode._retryCache;break;default:throw Error(w(314))}q!==null&&q.delete(M),f0(A,Z)}function n5(A,M){return BQ(A,M)}var t9=null,Lq=null,a2=!1,e9=!1,Y2=!1,GZ=0;function O7(A){A!==Lq&&A.next===null&&(Lq===null?t9=Lq=A:Lq=Lq.next=A),e9=!0,a2||(a2=!0,_5())}function SY(A,M){if(!Y2&&e9){Y2=!0;do{var Z=!1;for(var q=t9;q!==null;){if(!M)if(A!==0){var z=q.pendingLanes;if(z===0)var Y=0;else{var{suspendedLanes:V,pingedLanes:Q}=q;Y=(1<<31-SM(42|A)+1)-1,Y&=z&~(V&~Q),Y=Y&201326741?Y&201326741|1:Y?Y|2:0}Y!==0&&(Z=!0,aB(q,Y))}else Y=t,Y=Q3(q,q===JA?Y:0,q.cancelPendingCommit!==null||q.timeoutHandle!==-1),(Y&3)===0||HY(q,Y)||(Z=!0,aB(q,Y));q=q.next}}while(Z);Y2=!1}}function $5(){g0()}function g0(){e9=a2=!1;var A=0;GZ!==0&&YD()&&(A=GZ);for(var M=CM(),Z=null,q=t9;q!==null;){var z=q.next,Y=u0(q,M);if(Y===0)q.next=null,Z===null?t9=z:Z.next=z,z===null&&(Lq=Z);else if(Z=q,A!==0||(Y&3)!==0)e9=!0;q=z}pA!==0&&pA!==5||SY(A,!1),GZ!==0&&(GZ=0)}function u0(A,M){for(var{suspendedLanes:Z,pingedLanes:q,expirationTimes:z}=A,Y=A.pendingLanes&-62914561;0<Y;){var V=31-SM(Y),Q=1<<V,U=z[V];if(U===-1){if((Q&Z)===0||(Q&q)!==0)z[V]=HK(Q,M)}else U<=M&&(A.expiredLanes|=Q);Y&=~Q}if(M=JA,Z=t,Z=Q3(A,A===M?Z:0,A.cancelPendingCommit!==null||A.timeoutHandle!==-1),q=A.callbackNode,Z===0||A===M&&(QA===2||QA===9)||A.cancelPendingCommit!==null)return q!==null&&q!==null&&vV(q),A.callbackNode=null,A.callbackPriority=0;if((Z&3)===0||HY(A,Z)){if(M=Z&-Z,M===A.callbackPriority)return M;switch(q!==null&&vV(q),IQ(Z)){case 2:case 8:Z=LG;break;case 32:Z=v9;break;case 268435456:Z=wG;break;default:Z=v9}return q=m0.bind(null,A),Z=BQ(Z,q),A.callbackPriority=M,A.callbackNode=Z,M}return q!==null&&q!==null&&vV(q),A.callbackPriority=2,A.callbackNode=null,2}function m0(A,M){if(pA!==0&&pA!==5)return A.callbackNode=null,A.callbackPriority=0,null;var Z=A.callbackNode;if(E3()&&A.callbackNode!==Z)return null;var q=t;if(q=Q3(A,A===JA?q:0,A.cancelPendingCommit!==null||A.timeoutHandle!==-1),q===0)return null;return F0(A,q,M),u0(A,CM()),A.callbackNode!=null&&A.callbackNode===Z?m0.bind(null,A):null}function aB(A,M){if(E3())return null;F0(A,M,!0)}function _5(){QD(function(){(qA&6)!==0?BQ(FG,$5):g0()})}function nQ(){if(GZ===0){var A=nq;A===0&&(A=q9,q9<<=1,(q9&261888)===0&&(q9=256)),GZ=A}return GZ}function nB(A){return A==null||typeof A==="symbol"||typeof A==="boolean"?null:typeof A==="function"?A:N9(""+A)}function $B(A,M){var Z=M.ownerDocument.createElement("input");return Z.name=M.name,Z.value=M.value,A.id&&Z.setAttribute("form",A.id),M.parentNode.insertBefore(Z,M),A=new FormData(A),Z.parentNode.removeChild(Z),A}function t5(A,M,Z,q,z){if(M==="submit"&&Z&&Z.stateNode===z){var Y=nB((z[jM]||null).action),V=q.submitter;V&&(M=(M=V[jM]||null)?nB(M.formAction):V.getAttribute("formAction"),M!==null&&(Y=M,V=null));var Q=new U3("action","action",null,q,z);A.push({event:Q,listeners:[{instance:null,listener:function(){if(q.defaultPrevented){if(GZ!==0){var U=V?$B(z,V):new FormData(z);u2(Z,{pending:!0,data:U,method:z.method,action:Y},null,U)}}else typeof Y==="function"&&(Q.preventDefault(),U=V?$B(z,V):new FormData(z),u2(Z,{pending:!0,data:U,method:z.method,action:Y},Y,U))},currentTarget:z}]})}}for(sz=0;sz<w2.length;sz++)oz=w2[sz],n2=oz.toLowerCase(),$2=oz[0].toUpperCase()+oz.slice(1),Z7(n2,"on"+$2);var oz,n2,$2,sz;Z7(_G,"onAnimationEnd");Z7(tG,"onAnimationIteration");Z7(eG,"onAnimationStart");Z7("dblclick","onDoubleClick");Z7("focusin","onFocus");Z7("focusout","onBlur");Z7(D5,"onTransitionRun");Z7(N5,"onTransitionStart");Z7(j5,"onTransitionCancel");Z7(AI,"onTransitionEnd");oq("onMouseEnter",["mouseout","mouseover"]);oq("onMouseLeave",["mouseout","mouseover"]);oq("onPointerEnter",["pointerout","pointerover"]);oq("onPointerLeave",["pointerout","pointerover"]);$Z("onChange","change click focusin focusout input keydown keyup selectionchange".split(" "));$Z("onSelect","focusout contextmenu dragend focusin keydown keyup mousedown mouseup selectionchange".split(" "));$Z("onBeforeInput",["compositionend","keypress","textInput","paste"]);$Z("onCompositionEnd","compositionend focusout keydown keypress keyup mousedown".split(" "));$Z("onCompositionStart","compositionstart focusout keydown keypress keyup mousedown".split(" "));$Z("onCompositionUpdate","compositionupdate focusout keydown keypress keyup mousedown".split(" "));var DY="abort canplay canplaythrough durationchange emptied encrypted ended error loadeddata loadedmetadata loadstart pause play playing progress ratechange resize seeked seeking stalled suspend timeupdate volumechange waiting".split(" "),e5=new Set("beforetoggle cancel close invalid load scroll scrollend toggle".split(" ").concat(DY));function d0(A,M){M=(M&4)!==0;for(var Z=0;Z<A.length;Z++){var q=A[Z],z=q.event;q=q.listeners;A:{var Y=void 0;if(M)for(var V=q.length-1;0<=V;V--){var Q=q[V],U=Q.instance,B=Q.currentTarget;if(Q=Q.listener,U!==Y&&z.isPropagationStopped())break A;Y=Q,z.currentTarget=B;try{Y(z)}catch(W){g9(W)}z.currentTarget=null,Y=U}else for(V=0;V<q.length;V++){if(Q=q[V],U=Q.instance,B=Q.currentTarget,Q=Q.listener,U!==Y&&z.isPropagationStopped())break A;Y=Q,z.currentTarget=B;try{Y(z)}catch(W){g9(W)}z.currentTarget=null,Y=U}}}}function $(A,M){var Z=M[j2];Z===void 0&&(Z=M[j2]=new Set);var q=A+"__bubble";Z.has(q)||(p0(M,A,2,!1),Z.add(q))}function V2(A,M,Z){var q=0;M&&(q|=4),p0(Z,A,q,M)}var J9="_reactListening"+Math.random().toString(36).slice(2);function $Q(A){if(!A[J9]){A[J9]=!0,xG.forEach(function(Z){Z!=="selectionchange"&&(e5.has(Z)||V2(Z,!1,A),V2(Z,!0,A))});var M=A.nodeType===9?A:A.ownerDocument;M===null||M[J9]||(M[J9]=!0,V2("selectionchange",!1,M))}}function p0(A,M,Z,q){switch(AW(M)){case 2:var z=kD;break;case 8:z=CD;break;default:z=AU}Z=z.bind(null,M,Z,A),z=void 0,!H2||M!=="touchstart"&&M!=="touchmove"&&M!=="wheel"||(z=!0),q?z!==void 0?A.addEventListener(M,Z,{capture:!0,passive:z}):A.addEventListener(M,Z,!0):z!==void 0?A.addEventListener(M,Z,{passive:z}):A.addEventListener(M,Z,!1)}function Q2(A,M,Z,q,z){var Y=q;if((M&1)===0&&(M&2)===0&&q!==null)A:for(;;){if(q===null)return;var V=q.tag;if(V===3||V===4){var Q=q.stateNode.containerInfo;if(Q===z)break;if(V===4)for(V=q.return;V!==null;){var U=V.tag;if((U===3||U===4)&&V.stateNode.containerInfo===z)return;V=V.return}for(;Q!==null;){if(V=bq(Q),V===null)return;if(U=V.tag,U===5||U===6||U===26||U===27){q=Y=V;continue A}Q=Q.parentNode}}q=q.return}dG(function(){var B=Y,W=TQ(Z),J=[];A:{var I=MI.get(A);if(I!==void 0){var K=U3,N=A;switch(A){case"keypress":if(X9(Z)===0)break A;case"keydown":case"keyup":K=aK;break;case"focusin":N="focus",K=dV;break;case"focusout":N="blur",K=dV;break;case"beforeblur":case"afterblur":K=dV;break;case"click":if(Z.button===2)break A;case"auxclick":case"dblclick":case"mousedown":case"mousemove":case"mouseup":case"mouseout":case"mouseover":case"contextmenu":K=YB;break;case"drag":case"dragend":case"dragenter":case"dragexit":case"dragleave":case"dragover":case"dragstart":case"drop":K=fK;break;case"touchcancel":case"touchend":case"touchmove":case"touchstart":K=_K;break;case _G:case tG:case eG:K=mK;break;case AI:K=eK;break;case"scroll":case"scrollend":K=hK;break;case"wheel":K=M5;break;case"copy":case"cut":case"paste":K=pK;break;case"gotpointercapture":case"lostpointercapture":case"pointercancel":case"pointerdown":case"pointermove":case"pointerout":case"pointerover":case"pointerup":K=QB;break;case"toggle":case"beforetoggle":K=q5}var O=(M&4)!==0,j=!O&&(A==="scroll"||A==="scrollend"),T=O?I!==null?I+"Capture":null:I;O=[];for(var G=B,D;G!==null;){var X=G;if(D=X.stateNode,X=X.tag,X!==5&&X!==26&&X!==27||D===null||T===null||(X=UY(G,T),X!=null&&O.push(NY(G,X,D))),j)break;G=G.return}0<O.length&&(I=new K(I,N,null,Z,W),J.push({event:I,listeners:O}))}}if((M&7)===0){A:{if(I=A==="mouseover"||A==="pointerover",K=A==="mouseout"||A==="pointerout",I&&Z!==R2&&(N=Z.relatedTarget||Z.fromElement)&&(bq(N)||N[qz]))break A;if(K||I){if(I=W.window===W?W:(I=W.ownerDocument)?I.defaultView||I.parentWindow:window,K){if(N=Z.relatedTarget||Z.toElement,K=B,N=N?bq(N):null,N!==null&&(j=EY(N),O=N.tag,N!==j||O!==5&&O!==27&&O!==6))N=null}else K=null,N=B;if(K!==N){if(O=YB,X="onMouseLeave",T="onMouseEnter",G="mouse",A==="pointerout"||A==="pointerover")O=QB,X="onPointerLeave",T="onPointerEnter",G="pointer";if(j=K==null?I:pz(K),D=N==null?I:pz(N),I=new O(X,G+"leave",K,Z,W),I.target=j,I.relatedTarget=D,X=null,bq(W)===B&&(O=new O(T,G+"enter",N,Z,W),O.target=D,O.relatedTarget=j,X=O),j=X,K&&N)M:{O=AD,T=K,G=N,D=0;for(X=T;X;X=O(X))D++;X=0;for(var H=G;H;H=O(H))X++;for(;0<D-X;)T=O(T),D--;for(;0<X-D;)G=O(G),X--;for(;D--;){if(T===G||G!==null&&T===G.alternate){O=T;break M}T=O(T),G=O(G)}O=null}else O=null;K!==null&&_B(J,I,K,O,!1),N!==null&&j!==null&&_B(J,j,N,O,!0)}}}A:{if(I=B?pz(B):window,K=I.nodeName&&I.nodeName.toLowerCase(),K==="select"||K==="input"&&I.type==="file")var L=IB;else if(GB(I))if(sG)L=J5;else{L=I5;var F=G5}else K=I.nodeName,!K||K.toLowerCase()!=="input"||I.type!=="checkbox"&&I.type!=="radio"?B&&JQ(B.elementType)&&(L=IB):L=W5;if(L&&(L=L(A,B))){rG(J,L,Z,W);break A}F&&F(A,I,B),A==="focusout"&&B&&I.type==="number"&&B.memoizedProps.value!=null&&E2(I,"number",I.value)}switch(F=B?pz(B):window,A){case"focusin":if(GB(F)||F.contentEditable==="true")xq=F,F2=B,$z=null;break;case"focusout":$z=F2=xq=null;break;case"mousedown":L2=!0;break;case"contextmenu":case"mouseup":case"dragend":L2=!1,KB(J,Z,W);break;case"selectionchange":if(K5)break;case"keydown":case"keyup":KB(J,Z,W)}var R;if(NQ)A:{switch(A){case"compositionstart":var k="onCompositionStart";break A;case"compositionend":k="onCompositionEnd";break A;case"compositionupdate":k="onCompositionUpdate";break A}k=void 0}else Pq?lG(A,Z)&&(k="onCompositionEnd"):A==="keydown"&&Z.keyCode===229&&(k="onCompositionStart");if(k&&(cG&&Z.locale!=="ko"&&(Pq||k!=="onCompositionStart"?k==="onCompositionEnd"&&Pq&&(R=pG()):(QZ=W,KQ=("value"in QZ)?QZ.value:QZ.textContent,Pq=!0)),F=A3(B,k),0<F.length&&(k=new VB(k,A,null,Z,W),J.push({event:k,listeners:F}),R?k.data=R:(R=iG(Z),R!==null&&(k.data=R)))),R=Y5?V5(A,Z):Q5(A,Z))k=A3(B,"onBeforeInput"),0<k.length&&(F=new VB("onBeforeInput","beforeinput",null,Z,W),J.push({event:F,listeners:k}),F.data=R);t5(J,A,B,Z,W)}d0(J,M)})}function NY(A,M,Z){return{instance:A,listener:M,currentTarget:Z}}function A3(A,M){for(var Z=M+"Capture",q=[];A!==null;){var z=A,Y=z.stateNode;if(z=z.tag,z!==5&&z!==26&&z!==27||Y===null||(z=UY(A,Z),z!=null&&q.unshift(NY(A,z,Y)),z=UY(A,M),z!=null&&q.push(NY(A,z,Y))),A.tag===3)return q;A=A.return}return[]}function AD(A){if(A===null)return null;do A=A.return;while(A&&A.tag!==5&&A.tag!==27);return A?A:null}function _B(A,M,Z,q,z){for(var Y=M._reactName,V=[];Z!==null&&Z!==q;){var Q=Z,U=Q.alternate,B=Q.stateNode;if(Q=Q.tag,U!==null&&U===q)break;Q!==5&&Q!==26&&Q!==27||B===null||(U=B,z?(B=UY(Z,Y),B!=null&&V.unshift(NY(Z,B,U))):z||(B=UY(Z,Y),B!=null&&V.push(NY(Z,B,U)))),Z=Z.return}V.length!==0&&A.push({event:M,listeners:V})}var MD=/\r\n?/g,ZD=/\u0000|\uFFFD/g;function tB(A){return(typeof A==="string"?A:""+A).replace(MD,`
`).replace(ZD,"")}function c0(A,M){return M=tB(M),tB(A)===M?!0:!1}function BA(A,M,Z,q,z,Y){switch(Z){case"children":typeof q==="string"?M==="body"||M==="textarea"&&q===""||aq(A,q):(typeof q==="number"||typeof q==="bigint")&&M!=="body"&&aq(A,""+q);break;case"className":V9(A,"class",q);break;case"tabIndex":V9(A,"tabindex",q);break;case"dir":case"role":case"viewBox":case"width":case"height":V9(A,Z,q);break;case"style":mG(A,q,Y);break;case"data":if(M!=="object"){V9(A,"data",q);break}case"src":case"href":if(q===""&&(M!=="a"||Z!=="href")){A.removeAttribute(Z);break}if(q==null||typeof q==="function"||typeof q==="symbol"||typeof q==="boolean"){A.removeAttribute(Z);break}q=N9(""+q),A.setAttribute(Z,q);break;case"action":case"formAction":if(typeof q==="function"){A.setAttribute(Z,"javascript:throw new Error('A React form was unexpectedly submitted. If you called form.submit() manually, consider using form.requestSubmit() instead. If you\\'re trying to use event.stopPropagation() in a submit event handler, consider also calling event.preventDefault().')");break}else typeof Y==="function"&&(Z==="formAction"?(M!=="input"&&BA(A,M,"name",z.name,z,null),BA(A,M,"formEncType",z.formEncType,z,null),BA(A,M,"formMethod",z.formMethod,z,null),BA(A,M,"formTarget",z.formTarget,z,null)):(BA(A,M,"encType",z.encType,z,null),BA(A,M,"method",z.method,z,null),BA(A,M,"target",z.target,z,null)));if(q==null||typeof q==="symbol"||typeof q==="boolean"){A.removeAttribute(Z);break}q=N9(""+q),A.setAttribute(Z,q);break;case"onClick":q!=null&&(A.onclick=v7);break;case"onScroll":q!=null&&$("scroll",A);break;case"onScrollEnd":q!=null&&$("scrollend",A);break;case"dangerouslySetInnerHTML":if(q!=null){if(typeof q!=="object"||!("__html"in q))throw Error(w(61));if(Z=q.__html,Z!=null){if(z.children!=null)throw Error(w(60));A.innerHTML=Z}}break;case"multiple":A.multiple=q&&typeof q!=="function"&&typeof q!=="symbol";break;case"muted":A.muted=q&&typeof q!=="function"&&typeof q!=="symbol";break;case"suppressContentEditableWarning":case"suppressHydrationWarning":case"defaultValue":case"defaultChecked":case"innerHTML":case"ref":break;case"autoFocus":break;case"xlinkHref":if(q==null||typeof q==="function"||typeof q==="boolean"||typeof q==="symbol"){A.removeAttribute("xlink:href");break}Z=N9(""+q),A.setAttributeNS("http://www.w3.org/1999/xlink","xlink:href",Z);break;case"contentEditable":case"spellCheck":case"draggable":case"value":case"autoReverse":case"externalResourcesRequired":case"focusable":case"preserveAlpha":q!=null&&typeof q!=="function"&&typeof q!=="symbol"?A.setAttribute(Z,""+q):A.removeAttribute(Z);break;case"inert":case"allowFullScreen":case"async":case"autoPlay":case"controls":case"default":case"defer":case"disabled":case"disablePictureInPicture":case"disableRemotePlayback":case"formNoValidate":case"hidden":case"loop":case"noModule":case"noValidate":case"open":case"playsInline":case"readOnly":case"required":case"reversed":case"scoped":case"seamless":case"itemScope":q&&typeof q!=="function"&&typeof q!=="symbol"?A.setAttribute(Z,""):A.removeAttribute(Z);break;case"capture":case"download":q===!0?A.setAttribute(Z,""):q!==!1&&q!=null&&typeof q!=="function"&&typeof q!=="symbol"?A.setAttribute(Z,q):A.removeAttribute(Z);break;case"cols":case"rows":case"size":case"span":q!=null&&typeof q!=="function"&&typeof q!=="symbol"&&!isNaN(q)&&1<=q?A.setAttribute(Z,q):A.removeAttribute(Z);break;case"rowSpan":case"start":q==null||typeof q==="function"||typeof q==="symbol"||isNaN(q)?A.removeAttribute(Z):A.setAttribute(Z,q);break;case"popover":$("beforetoggle",A),$("toggle",A),D9(A,"popover",q);break;case"xlinkActuate":k7(A,"http://www.w3.org/1999/xlink","xlink:actuate",q);break;case"xlinkArcrole":k7(A,"http://www.w3.org/1999/xlink","xlink:arcrole",q);break;case"xlinkRole":k7(A,"http://www.w3.org/1999/xlink","xlink:role",q);break;case"xlinkShow":k7(A,"http://www.w3.org/1999/xlink","xlink:show",q);break;case"xlinkTitle":k7(A,"http://www.w3.org/1999/xlink","xlink:title",q);break;case"xlinkType":k7(A,"http://www.w3.org/1999/xlink","xlink:type",q);break;case"xmlBase":k7(A,"http://www.w3.org/XML/1998/namespace","xml:base",q);break;case"xmlLang":k7(A,"http://www.w3.org/XML/1998/namespace","xml:lang",q);break;case"xmlSpace":k7(A,"http://www.w3.org/XML/1998/namespace","xml:space",q);break;case"is":D9(A,"is",q);break;case"innerText":case"textContent":break;default:if(!(2<Z.length)||Z[0]!=="o"&&Z[0]!=="O"||Z[1]!=="n"&&Z[1]!=="N")Z=xK.get(Z)||Z,D9(A,Z,q)}}function _2(A,M,Z,q,z,Y){switch(Z){case"style":mG(A,q,Y);break;case"dangerouslySetInnerHTML":if(q!=null){if(typeof q!=="object"||!("__html"in q))throw Error(w(61));if(Z=q.__html,Z!=null){if(z.children!=null)throw Error(w(60));A.innerHTML=Z}}break;case"children":typeof q==="string"?aq(A,q):(typeof q==="number"||typeof q==="bigint")&&aq(A,""+q);break;case"onScroll":q!=null&&$("scroll",A);break;case"onScrollEnd":q!=null&&$("scrollend",A);break;case"onClick":q!=null&&(A.onclick=v7);break;case"suppressContentEditableWarning":case"suppressHydrationWarning":case"innerHTML":case"ref":break;case"innerText":case"textContent":break;default:if(!yG.hasOwnProperty(Z))A:{if(Z[0]==="o"&&Z[1]==="n"&&(z=Z.endsWith("Capture"),M=Z.slice(2,z?Z.length-7:void 0),Y=A[jM]||null,Y=Y!=null?Y[Z]:null,typeof Y==="function"&&A.removeEventListener(M,Y,z),typeof q==="function")){typeof Y!=="function"&&Y!==null&&(Z in A?A[Z]=null:A.hasAttribute(Z)&&A.removeAttribute(Z)),A.addEventListener(M,q,z);break A}Z in A?A[Z]=q:q===!0?A.setAttribute(Z,""):D9(A,Z,q)}}}function AM(A,M,Z){switch(M){case"div":case"span":case"svg":case"path":case"a":case"g":case"p":case"li":break;case"img":$("error",A),$("load",A);var q=!1,z=!1,Y;for(Y in Z)if(Z.hasOwnProperty(Y)){var V=Z[Y];if(V!=null)switch(Y){case"src":q=!0;break;case"srcSet":z=!0;break;case"children":case"dangerouslySetInnerHTML":throw Error(w(137,M));default:BA(A,M,Y,V,Z,null)}}z&&BA(A,M,"srcSet",Z.srcSet,Z,null),q&&BA(A,M,"src",Z.src,Z,null);return;case"input":$("invalid",A);var Q=Y=V=z=null,U=null,B=null;for(q in Z)if(Z.hasOwnProperty(q)){var W=Z[q];if(W!=null)switch(q){case"name":z=W;break;case"type":V=W;break;case"checked":U=W;break;case"defaultChecked":B=W;break;case"value":Y=W;break;case"defaultValue":Q=W;break;case"children":case"dangerouslySetInnerHTML":if(W!=null)throw Error(w(137,M));break;default:BA(A,M,q,W,Z,null)}}fG(A,Y,Q,U,B,V,z,!1);return;case"select":$("invalid",A),q=V=Y=null;for(z in Z)if(Z.hasOwnProperty(z)&&(Q=Z[z],Q!=null))switch(z){case"value":Y=Q;break;case"defaultValue":V=Q;break;case"multiple":q=Q;default:BA(A,M,z,Q,Z,null)}M=Y,Z=V,A.multiple=!!q,M!=null?dq(A,!!q,M,!1):Z!=null&&dq(A,!!q,Z,!0);return;case"textarea":$("invalid",A),Y=z=q=null;for(V in Z)if(Z.hasOwnProperty(V)&&(Q=Z[V],Q!=null))switch(V){case"value":q=Q;break;case"defaultValue":z=Q;break;case"children":Y=Q;break;case"dangerouslySetInnerHTML":if(Q!=null)throw Error(w(91));break;default:BA(A,M,V,Q,Z,null)}uG(A,q,z,Y);return;case"option":for(U in Z)if(Z.hasOwnProperty(U)&&(q=Z[U],q!=null))switch(U){case"selected":A.selected=q&&typeof q!=="function"&&typeof q!=="symbol";break;default:BA(A,M,U,q,Z,null)}return;case"dialog":$("beforetoggle",A),$("toggle",A),$("cancel",A),$("close",A);break;case"iframe":case"object":$("load",A);break;case"video":case"audio":for(q=0;q<DY.length;q++)$(DY[q],A);break;case"image":$("error",A),$("load",A);break;case"details":$("toggle",A);break;case"embed":case"source":case"link":$("error",A),$("load",A);case"area":case"base":case"br":case"col":case"hr":case"keygen":case"meta":case"param":case"track":case"wbr":case"menuitem":for(B in Z)if(Z.hasOwnProperty(B)&&(q=Z[B],q!=null))switch(B){case"children":case"dangerouslySetInnerHTML":throw Error(w(137,M));default:BA(A,M,B,q,Z,null)}return;default:if(JQ(M)){for(W in Z)Z.hasOwnProperty(W)&&(q=Z[W],q!==void 0&&_2(A,M,W,q,Z,void 0));return}}for(Q in Z)Z.hasOwnProperty(Q)&&(q=Z[Q],q!=null&&BA(A,M,Q,q,Z,null))}function qD(A,M,Z,q){switch(M){case"div":case"span":case"svg":case"path":case"a":case"g":case"p":case"li":break;case"input":var z=null,Y=null,V=null,Q=null,U=null,B=null,W=null;for(K in Z){var J=Z[K];if(Z.hasOwnProperty(K)&&J!=null)switch(K){case"checked":break;case"value":break;case"defaultValue":U=J;default:q.hasOwnProperty(K)||BA(A,M,K,null,q,J)}}for(var I in q){var K=q[I];if(J=Z[I],q.hasOwnProperty(I)&&(K!=null||J!=null))switch(I){case"type":Y=K;break;case"name":z=K;break;case"checked":B=K;break;case"defaultChecked":W=K;break;case"value":V=K;break;case"defaultValue":Q=K;break;case"children":case"dangerouslySetInnerHTML":if(K!=null)throw Error(w(137,M));break;default:K!==J&&BA(A,M,I,K,q,J)}}O2(A,V,Q,U,B,W,Y,z);return;case"select":K=V=Q=I=null;for(Y in Z)if(U=Z[Y],Z.hasOwnProperty(Y)&&U!=null)switch(Y){case"value":break;case"multiple":K=U;default:q.hasOwnProperty(Y)||BA(A,M,Y,null,q,U)}for(z in q)if(Y=q[z],U=Z[z],q.hasOwnProperty(z)&&(Y!=null||U!=null))switch(z){case"value":I=Y;break;case"defaultValue":Q=Y;break;case"multiple":V=Y;default:Y!==U&&BA(A,M,z,Y,q,U)}M=Q,Z=V,q=K,I!=null?dq(A,!!Z,I,!1):!!q!==!!Z&&(M!=null?dq(A,!!Z,M,!0):dq(A,!!Z,Z?[]:"",!1));return;case"textarea":K=I=null;for(Q in Z)if(z=Z[Q],Z.hasOwnProperty(Q)&&z!=null&&!q.hasOwnProperty(Q))switch(Q){case"value":break;case"children":break;default:BA(A,M,Q,null,q,z)}for(V in q)if(z=q[V],Y=Z[V],q.hasOwnProperty(V)&&(z!=null||Y!=null))switch(V){case"value":I=z;break;case"defaultValue":K=z;break;case"children":break;case"dangerouslySetInnerHTML":if(z!=null)throw Error(w(91));break;default:z!==Y&&BA(A,M,V,z,q,Y)}gG(A,I,K);return;case"option":for(var N in Z)if(I=Z[N],Z.hasOwnProperty(N)&&I!=null&&!q.hasOwnProperty(N))switch(N){case"selected":A.selected=!1;break;default:BA(A,M,N,null,q,I)}for(U in q)if(I=q[U],K=Z[U],q.hasOwnProperty(U)&&I!==K&&(I!=null||K!=null))switch(U){case"selected":A.selected=I&&typeof I!=="function"&&typeof I!=="symbol";break;default:BA(A,M,U,I,q,K)}return;case"img":case"link":case"area":case"base":case"br":case"col":case"embed":case"hr":case"keygen":case"meta":case"param":case"source":case"track":case"wbr":case"menuitem":for(var O in Z)I=Z[O],Z.hasOwnProperty(O)&&I!=null&&!q.hasOwnProperty(O)&&BA(A,M,O,null,q,I);for(B in q)if(I=q[B],K=Z[B],q.hasOwnProperty(B)&&I!==K&&(I!=null||K!=null))switch(B){case"children":case"dangerouslySetInnerHTML":if(I!=null)throw Error(w(137,M));break;default:BA(A,M,B,I,q,K)}return;default:if(JQ(M)){for(var j in Z)I=Z[j],Z.hasOwnProperty(j)&&I!==void 0&&!q.hasOwnProperty(j)&&_2(A,M,j,void 0,q,I);for(W in q)I=q[W],K=Z[W],!q.hasOwnProperty(W)||I===K||I===void 0&&K===void 0||_2(A,M,W,I,q,K);return}}for(var T in Z)I=Z[T],Z.hasOwnProperty(T)&&I!=null&&!q.hasOwnProperty(T)&&BA(A,M,T,null,q,I);for(J in q)I=q[J],K=Z[J],!q.hasOwnProperty(J)||I===K||I==null&&K==null||BA(A,M,J,I,q,K)}function eB(A){switch(A){case"css":case"script":case"font":case"img":case"image":case"input":case"link":return!0;default:return!1}}function zD(){if(typeof performance.getEntriesByType==="function"){for(var A=0,M=0,Z=performance.getEntriesByType("resource"),q=0;q<Z.length;q++){var z=Z[q],Y=z.transferSize,V=z.initiatorType,Q=z.duration;if(Y&&Q&&eB(V)){V=0,Q=z.responseEnd;for(q+=1;q<Z.length;q++){var U=Z[q],B=U.startTime;if(B>Q)break;var{transferSize:W,initiatorType:J}=U;W&&eB(J)&&(U=U.responseEnd,V+=W*(U<Q?1:(Q-B)/(U-B)))}if(--q,M+=8*(Y+V)/(z.duration/1000),A++,10<A)break}}if(0<A)return M/A/1e6}return navigator.connection&&(A=navigator.connection.downlink,typeof A==="number")?A:5}var t2=null,e2=null;function M3(A){return A.nodeType===9?A:A.ownerDocument}function AG(A){switch(A){case"http://www.w3.org/2000/svg":return 1;case"http://www.w3.org/1998/Math/MathML":return 2;default:return 0}}function l0(A,M){if(A===0)switch(M){case"svg":return 1;case"math":return 2;default:return 0}return A===1&&M==="foreignObject"?0:A}function AQ(A,M){return A==="textarea"||A==="noscript"||typeof M.children==="string"||typeof M.children==="number"||typeof M.children==="bigint"||typeof M.dangerouslySetInnerHTML==="object"&&M.dangerouslySetInnerHTML!==null&&M.dangerouslySetInnerHTML.__html!=null}var U2=null;function YD(){var A=window.event;if(A&&A.type==="popstate"){if(A===U2)return!1;return U2=A,!0}return U2=null,!1}var i0=typeof setTimeout==="function"?setTimeout:void 0,VD=typeof clearTimeout==="function"?clearTimeout:void 0,MG=typeof Promise==="function"?Promise:void 0,QD=typeof queueMicrotask==="function"?queueMicrotask:typeof MG<"u"?function(A){return MG.resolve(null).then(A).catch(UD)}:i0;function UD(A){setTimeout(function(){throw A})}function LZ(A){return A==="head"}function ZG(A,M){var Z=M,q=0;do{var z=Z.nextSibling;if(A.removeChild(Z),z&&z.nodeType===8)if(Z=z.data,Z==="/$"||Z==="/&"){if(q===0){A.removeChild(z),Zz(M);return}q--}else if(Z==="$"||Z==="$?"||Z==="$~"||Z==="$!"||Z==="&")q++;else if(Z==="html")VY(A.ownerDocument.documentElement);else if(Z==="head"){Z=A.ownerDocument.head,VY(Z);for(var Y=Z.firstChild;Y;){var{nextSibling:V,nodeName:Q}=Y;Y[LY]||Q==="SCRIPT"||Q==="STYLE"||Q==="LINK"&&Y.rel.toLowerCase()==="stylesheet"||Z.removeChild(Y),Y=V}}else Z==="body"&&VY(A.ownerDocument.body);Z=z}while(Z);Zz(M)}function qG(A,M){var Z=A;A=0;do{var q=Z.nextSibling;if(Z.nodeType===1?M?(Z._stashedDisplay=Z.style.display,Z.style.display="none"):(Z.style.display=Z._stashedDisplay||"",Z.getAttribute("style")===""&&Z.removeAttribute("style")):Z.nodeType===3&&(M?(Z._stashedText=Z.nodeValue,Z.nodeValue=""):Z.nodeValue=Z._stashedText||""),q&&q.nodeType===8)if(Z=q.data,Z==="/$")if(A===0)break;else A--;else Z!=="$"&&Z!=="$?"&&Z!=="$~"&&Z!=="$!"||A++;Z=q}while(Z)}function MQ(A){var M=A.firstChild;M&&M.nodeType===10&&(M=M.nextSibling);for(;M;){var Z=M;switch(M=M.nextSibling,Z.nodeName){case"HTML":case"HEAD":case"BODY":MQ(Z),WQ(Z);continue;case"SCRIPT":case"STYLE":continue;case"LINK":if(Z.rel.toLowerCase()==="stylesheet")continue}A.removeChild(Z)}}function BD(A,M,Z,q){for(;A.nodeType===1;){var z=Z;if(A.nodeName.toLowerCase()!==M.toLowerCase()){if(!q&&(A.nodeName!=="INPUT"||A.type!=="hidden"))break}else if(!q)if(M==="input"&&A.type==="hidden"){var Y=z.name==null?null:""+z.name;if(z.type==="hidden"&&A.getAttribute("name")===Y)return A}else return A;else if(!A[LY])switch(M){case"meta":if(!A.hasAttribute("itemprop"))break;return A;case"link":if(Y=A.getAttribute("rel"),Y==="stylesheet"&&A.hasAttribute("data-precedence"))break;else if(Y!==z.rel||A.getAttribute("href")!==(z.href==null||z.href===""?null:z.href)||A.getAttribute("crossorigin")!==(z.crossOrigin==null?null:z.crossOrigin)||A.getAttribute("title")!==(z.title==null?null:z.title))break;return A;case"style":if(A.hasAttribute("data-precedence"))break;return A;case"script":if(Y=A.getAttribute("src"),(Y!==(z.src==null?null:z.src)||A.getAttribute("type")!==(z.type==null?null:z.type)||A.getAttribute("crossorigin")!==(z.crossOrigin==null?null:z.crossOrigin))&&Y&&A.hasAttribute("async")&&!A.hasAttribute("itemprop"))break;return A;default:return A}if(A=oM(A.nextSibling),A===null)break}return null}function GD(A,M,Z){if(M==="")return null;for(;A.nodeType!==3;){if((A.nodeType!==1||A.nodeName!=="INPUT"||A.type!=="hidden")&&!Z)return null;if(A=oM(A.nextSibling),A===null)return null}return A}function r0(A,M){for(;A.nodeType!==8;){if((A.nodeType!==1||A.nodeName!=="INPUT"||A.type!=="hidden")&&!M)return null;if(A=oM(A.nextSibling),A===null)return null}return A}function ZQ(A){return A.data==="$?"||A.data==="$~"}function qQ(A){return A.data==="$!"||A.data==="$?"&&A.ownerDocument.readyState!=="loading"}function ID(A,M){var Z=A.ownerDocument;if(A.data==="$~")A._reactRetry=M;else if(A.data!=="$?"||Z.readyState!=="loading")M();else{var q=function(){M(),Z.removeEventListener("DOMContentLoaded",q)};Z.addEventListener("DOMContentLoaded",q),A._reactRetry=q}}function oM(A){for(;A!=null;A=A.nextSibling){var M=A.nodeType;if(M===1||M===3)break;if(M===8){if(M=A.data,M==="$"||M==="$!"||M==="$?"||M==="$~"||M==="&"||M==="F!"||M==="F")break;if(M==="/$"||M==="/&")return null}}return A}var zQ=null;function zG(A){A=A.nextSibling;for(var M=0;A;){if(A.nodeType===8){var Z=A.data;if(Z==="/$"||Z==="/&"){if(M===0)return oM(A.nextSibling);M--}else Z!=="$"&&Z!=="$!"&&Z!=="$?"&&Z!=="$~"&&Z!=="&"||M++}A=A.nextSibling}return null}function YG(A){A=A.previousSibling;for(var M=0;A;){if(A.nodeType===8){var Z=A.data;if(Z==="$"||Z==="$!"||Z==="$?"||Z==="$~"||Z==="&"){if(M===0)return A;M--}else Z!=="/$"&&Z!=="/&"||M++}A=A.previousSibling}return null}function s0(A,M,Z){switch(M=M3(Z),A){case"html":if(A=M.documentElement,!A)throw Error(w(452));return A;case"head":if(A=M.head,!A)throw Error(w(453));return A;case"body":if(A=M.body,!A)throw Error(w(454));return A;default:throw Error(w(451))}}function VY(A){for(var M=A.attributes;M.length;)A.removeAttributeNode(M[0]);WQ(A)}var aM=new Map,VG=new Set;function Z3(A){return typeof A.getRootNode==="function"?A.getRootNode():A.nodeType===9?A:A.ownerDocument}var r7=zA.d;zA.d={f:WD,r:JD,D:TD,C:KD,L:DD,m:ND,X:XD,S:jD,M:OD};function WD(){var A=r7.f(),M=X3();return A||M}function JD(A){var M=zz(A);M!==null&&M.tag===5&&M.type==="form"?mI(M):r7.r(A)}var Uz=typeof document>"u"?null:document;function o0(A,M,Z){var q=Uz;if(q&&typeof M==="string"&&M){var z=lM(M);z='link[rel="'+A+'"][href="'+z+'"]',typeof Z==="string"&&(z+='[crossorigin="'+Z+'"]'),VG.has(z)||(VG.add(z),A={rel:A,crossOrigin:Z,href:M},q.querySelector(z)===null&&(M=q.createElement("link"),AM(M,"link",A),rA(M),q.head.appendChild(M)))}}function TD(A){r7.D(A),o0("dns-prefetch",A,null)}function KD(A,M){r7.C(A,M),o0("preconnect",A,M)}function DD(A,M,Z){r7.L(A,M,Z);var q=Uz;if(q&&A&&M){var z='link[rel="preload"][as="'+lM(M)+'"]';M==="image"?Z&&Z.imageSrcSet?(z+='[imagesrcset="'+lM(Z.imageSrcSet)+'"]',typeof Z.imageSizes==="string"&&(z+='[imagesizes="'+lM(Z.imageSizes)+'"]')):z+='[href="'+lM(A)+'"]':z+='[href="'+lM(A)+'"]';var Y=z;switch(M){case"style":Y=Mz(A);break;case"script":Y=Bz(A)}aM.has(Y)||(A=XA({rel:"preload",href:M==="image"&&Z&&Z.imageSrcSet?void 0:A,as:M},Z),aM.set(Y,A),q.querySelector(z)!==null||M==="style"&&q.querySelector(PY(Y))||M==="script"&&q.querySelector(xY(Y))||(M=q.createElement("link"),AM(M,"link",A),rA(M),q.head.appendChild(M)))}}function ND(A,M){r7.m(A,M);var Z=Uz;if(Z&&A){var q=M&&typeof M.as==="string"?M.as:"script",z='link[rel="modulepreload"][as="'+lM(q)+'"][href="'+lM(A)+'"]',Y=z;switch(q){case"audioworklet":case"paintworklet":case"serviceworker":case"sharedworker":case"worker":case"script":Y=Bz(A)}if(!aM.has(Y)&&(A=XA({rel:"modulepreload",href:A},M),aM.set(Y,A),Z.querySelector(z)===null)){switch(q){case"audioworklet":case"paintworklet":case"serviceworker":case"sharedworker":case"worker":case"script":if(Z.querySelector(xY(Y)))return}q=Z.createElement("link"),AM(q,"link",A),rA(q),Z.head.appendChild(q)}}}function jD(A,M,Z){r7.S(A,M,Z);var q=Uz;if(q&&A){var z=mq(q).hoistableStyles,Y=Mz(A);M=M||"default";var V=z.get(Y);if(!V){var Q={loading:0,preload:null};if(V=q.querySelector(PY(Y)))Q.loading=5;else{A=XA({rel:"stylesheet",href:A,"data-precedence":M},Z),(Z=aM.get(Y))&&_Q(A,Z);var U=V=q.createElement("link");rA(U),AM(U,"link",A),U._p=new Promise(function(B,W){U.onload=B,U.onerror=W}),U.addEventListener("load",function(){Q.loading|=1}),U.addEventListener("error",function(){Q.loading|=2}),Q.loading|=4,C9(V,M,q)}V={type:"stylesheet",instance:V,count:1,state:Q},z.set(Y,V)}}}function XD(A,M){r7.X(A,M);var Z=Uz;if(Z&&A){var q=mq(Z).hoistableScripts,z=Bz(A),Y=q.get(z);Y||(Y=Z.querySelector(xY(z)),Y||(A=XA({src:A,async:!0},M),(M=aM.get(z))&&tQ(A,M),Y=Z.createElement("script"),rA(Y),AM(Y,"link",A),Z.head.appendChild(Y)),Y={type:"script",instance:Y,count:1,state:null},q.set(z,Y))}}function OD(A,M){r7.M(A,M);var Z=Uz;if(Z&&A){var q=mq(Z).hoistableScripts,z=Bz(A),Y=q.get(z);Y||(Y=Z.querySelector(xY(z)),Y||(A=XA({src:A,async:!0,type:"module"},M),(M=aM.get(z))&&tQ(A,M),Y=Z.createElement("script"),rA(Y),AM(Y,"link",A),Z.head.appendChild(Y)),Y={type:"script",instance:Y,count:1,state:null},q.set(z,Y))}}function QG(A,M,Z,q){var z=(z=IZ.current)?Z3(z):null;if(!z)throw Error(w(446));switch(A){case"meta":case"title":return null;case"style":return typeof Z.precedence==="string"&&typeof Z.href==="string"?(M=Mz(Z.href),Z=mq(z).hoistableStyles,q=Z.get(M),q||(q={type:"style",instance:null,count:0,state:null},Z.set(M,q)),q):{type:"void",instance:null,count:0,state:null};case"link":if(Z.rel==="stylesheet"&&typeof Z.href==="string"&&typeof Z.precedence==="string"){A=Mz(Z.href);var Y=mq(z).hoistableStyles,V=Y.get(A);if(V||(z=z.ownerDocument||z,V={type:"stylesheet",instance:null,count:0,state:{loading:0,preload:null}},Y.set(A,V),(Y=z.querySelector(PY(A)))&&!Y._p&&(V.instance=Y,V.state.loading=5),aM.has(A)||(Z={rel:"preload",as:"style",href:Z.href,crossOrigin:Z.crossOrigin,integrity:Z.integrity,media:Z.media,hrefLang:Z.hrefLang,referrerPolicy:Z.referrerPolicy},aM.set(A,Z),Y||ED(z,A,Z,V.state))),M&&q===null)throw Error(w(528,""));return V}if(M&&q!==null)throw Error(w(529,""));return null;case"script":return M=Z.async,Z=Z.src,typeof Z==="string"&&M&&typeof M!=="function"&&typeof M!=="symbol"?(M=Bz(Z),Z=mq(z).hoistableScripts,q=Z.get(M),q||(q={type:"script",instance:null,count:0,state:null},Z.set(M,q)),q):{type:"void",instance:null,count:0,state:null};default:throw Error(w(444,A))}}function Mz(A){return'href="'+lM(A)+'"'}function PY(A){return'link[rel="stylesheet"]['+A+"]"}function a0(A){return XA({},A,{"data-precedence":A.precedence,precedence:null})}function ED(A,M,Z,q){A.querySelector('link[rel="preload"][as="style"]['+M+"]")?q.loading=1:(M=A.createElement("link"),q.preload=M,M.addEventListener("load",function(){return q.loading|=1}),M.addEventListener("error",function(){return q.loading|=2}),AM(M,"link",Z),rA(M),A.head.appendChild(M))}function Bz(A){return'[src="'+lM(A)+'"]'}function xY(A){return"script[async]"+A}function UG(A,M,Z){if(M.count++,M.instance===null)switch(M.type){case"style":var q=A.querySelector('style[data-href~="'+lM(Z.href)+'"]');if(q)return M.instance=q,rA(q),q;var z=XA({},Z,{"data-href":Z.href,"data-precedence":Z.precedence,href:null,precedence:null});return q=(A.ownerDocument||A).createElement("style"),rA(q),AM(q,"style",z),C9(q,Z.precedence,A),M.instance=q;case"stylesheet":z=Mz(Z.href);var Y=A.querySelector(PY(z));if(Y)return M.state.loading|=4,M.instance=Y,rA(Y),Y;q=a0(Z),(z=aM.get(z))&&_Q(q,z),Y=(A.ownerDocument||A).createElement("link"),rA(Y);var V=Y;return V._p=new Promise(function(Q,U){V.onload=Q,V.onerror=U}),AM(Y,"link",q),M.state.loading|=4,C9(Y,Z.precedence,A),M.instance=Y;case"script":if(Y=Bz(Z.src),z=A.querySelector(xY(Y)))return M.instance=z,rA(z),z;if(q=Z,z=aM.get(Y))q=XA({},Z),tQ(q,z);return A=A.ownerDocument||A,z=A.createElement("script"),rA(z),AM(z,"link",q),A.head.appendChild(z),M.instance=z;case"void":return null;default:throw Error(w(443,M.type))}else M.type==="stylesheet"&&(M.state.loading&4)===0&&(q=M.instance,M.state.loading|=4,C9(q,Z.precedence,A));return M.instance}function C9(A,M,Z){for(var q=Z.querySelectorAll('link[rel="stylesheet"][data-precedence],style[data-precedence]'),z=q.length?q[q.length-1]:null,Y=z,V=0;V<q.length;V++){var Q=q[V];if(Q.dataset.precedence===M)Y=Q;else if(Y!==z)break}Y?Y.parentNode.insertBefore(A,Y.nextSibling):(M=Z.nodeType===9?Z.head:Z,M.insertBefore(A,M.firstChild))}function _Q(A,M){A.crossOrigin==null&&(A.crossOrigin=M.crossOrigin),A.referrerPolicy==null&&(A.referrerPolicy=M.referrerPolicy),A.title==null&&(A.title=M.title)}function tQ(A,M){A.crossOrigin==null&&(A.crossOrigin=M.crossOrigin),A.referrerPolicy==null&&(A.referrerPolicy=M.referrerPolicy),A.integrity==null&&(A.integrity=M.integrity)}var b9=null;function BG(A,M,Z){if(b9===null){var q=new Map,z=b9=new Map;z.set(Z,q)}else z=b9,q=z.get(Z),q||(q=new Map,z.set(Z,q));if(q.has(A))return q;q.set(A,null),Z=Z.getElementsByTagName(A);for(z=0;z<Z.length;z++){var Y=Z[z];if(!(Y[LY]||Y[_A]||A==="link"&&Y.getAttribute("rel")==="stylesheet")&&Y.namespaceURI!=="http://www.w3.org/2000/svg"){var V=Y.getAttribute(M)||"";V=A+V;var Q=q.get(V);Q?Q.push(Y):q.set(V,[Y])}}return q}function GG(A,M,Z){A=A.ownerDocument||A,A.head.insertBefore(Z,M==="title"?A.querySelector("head > title"):null)}function RD(A,M,Z){if(Z===1||M.itemProp!=null)return!1;switch(A){case"meta":case"title":return!0;case"style":if(typeof M.precedence!=="string"||typeof M.href!=="string"||M.href==="")break;return!0;case"link":if(typeof M.rel!=="string"||typeof M.href!=="string"||M.href===""||M.onLoad||M.onError)break;switch(M.rel){case"stylesheet":return A=M.disabled,typeof M.precedence==="string"&&A==null;default:return!0}case"script":if(M.async&&typeof M.async!=="function"&&typeof M.async!=="symbol"&&!M.onLoad&&!M.onError&&M.src&&typeof M.src==="string")return!0}return!1}function n0(A){return A.type==="stylesheet"&&(A.state.loading&3)===0?!1:!0}function HD(A,M,Z,q){if(Z.type==="stylesheet"&&(typeof q.media!=="string"||matchMedia(q.media).matches!==!1)&&(Z.state.loading&4)===0){if(Z.instance===null){var z=Mz(q.href),Y=M.querySelector(PY(z));if(Y){M=Y._p,M!==null&&typeof M==="object"&&typeof M.then==="function"&&(A.count++,A=q3.bind(A),M.then(A,A)),Z.state.loading|=4,Z.instance=Y,rA(Y);return}Y=M.ownerDocument||M,q=a0(q),(z=aM.get(z))&&_Q(q,z),Y=Y.createElement("link"),rA(Y);var V=Y;V._p=new Promise(function(Q,U){V.onload=Q,V.onerror=U}),AM(Y,"link",q),Z.instance=Y}A.stylesheets===null&&(A.stylesheets=new Map),A.stylesheets.set(Z,M),(M=Z.state.preload)&&(Z.state.loading&3)===0&&(A.count++,Z=q3.bind(A),M.addEventListener("load",Z),M.addEventListener("error",Z))}}var B2=0;function FD(A,M){return A.stylesheets&&A.count===0&&S9(A,A.stylesheets),0<A.count||0<A.imgCount?function(Z){var q=setTimeout(function(){if(A.stylesheets&&S9(A,A.stylesheets),A.unsuspend){var Y=A.unsuspend;A.unsuspend=null,Y()}},60000+M);0<A.imgBytes&&B2===0&&(B2=62500*zD());var z=setTimeout(function(){if(A.waitingForImages=!1,A.count===0&&(A.stylesheets&&S9(A,A.stylesheets),A.unsuspend)){var Y=A.unsuspend;A.unsuspend=null,Y()}},(A.imgBytes>B2?50:800)+M);return A.unsuspend=Z,function(){A.unsuspend=null,clearTimeout(q),clearTimeout(z)}}:null}function q3(){if(this.count--,this.count===0&&(this.imgCount===0||!this.waitingForImages)){if(this.stylesheets)S9(this,this.stylesheets);else if(this.unsuspend){var A=this.unsuspend;this.unsuspend=null,A()}}}var z3=null;function S9(A,M){A.stylesheets=null,A.unsuspend!==null&&(A.count++,z3=new Map,M.forEach(LD,A),z3=null,q3.call(A))}function LD(A,M){if(!(M.state.loading&4)){var Z=z3.get(A);if(Z)var q=Z.get(null);else{Z=new Map,z3.set(A,Z);for(var z=A.querySelectorAll("link[data-precedence],style[data-precedence]"),Y=0;Y<z.length;Y++){var V=z[Y];if(V.nodeName==="LINK"||V.getAttribute("media")!=="not all")Z.set(V.dataset.precedence,V),q=V}q&&Z.set(null,q)}z=M.instance,V=z.getAttribute("data-precedence"),Y=Z.get(V)||q,Y===q&&Z.set(null,z),Z.set(V,z),this.count++,q=q3.bind(this),z.addEventListener("load",q),z.addEventListener("error",q),Y?Y.parentNode.insertBefore(z,Y.nextSibling):(A=A.nodeType===9?A.head:A,A.insertBefore(z,A.firstChild)),M.state.loading|=4}}var jY={$$typeof:h7,Provider:null,Consumer:null,_currentValue:dZ,_currentValue2:dZ,_threadCount:0};function wD(A,M,Z,q,z,Y,V,Q,U){this.tag=1,this.containerInfo=A,this.pingCache=this.current=this.pendingChildren=null,this.timeoutHandle=-1,this.callbackNode=this.next=this.pendingContext=this.context=this.cancelPendingCommit=null,this.callbackPriority=0,this.expirationTimes=fV(-1),this.entangledLanes=this.shellSuspendCounter=this.errorRecoveryDisabledLanes=this.expiredLanes=this.warmLanes=this.pingedLanes=this.suspendedLanes=this.pendingLanes=0,this.entanglements=fV(0),this.hiddenUpdates=fV(null),this.identifierPrefix=q,this.onUncaughtError=z,this.onCaughtError=Y,this.onRecoverableError=V,this.pooledCache=null,this.pooledCacheLanes=0,this.formState=U,this.incompleteTransitions=new Map}function $0(A,M,Z,q,z,Y,V,Q,U,B,W,J){return A=new wD(A,M,Z,V,U,B,W,J,Q),M=1,Y===!0&&(M|=24),Y=wM(3,null,null,M),A.current=Y,Y.stateNode=A,M=FQ(),M.refCount++,A.pooledCache=M,M.refCount++,Y.memoizedState={element:q,isDehydrated:Z,cache:M},kQ(Y),A}function _0(A){if(!A)return vq;return A=vq,A}function t0(A,M,Z,q,z,Y){z=_0(z),q.context===null?q.context=z:q.pendingContext=z,q=JZ(M),q.payload={element:Z},Y=Y===void 0?null:Y,Y!==null&&(q.callback=Y),Z=TZ(A,q,M),Z!==null&&(NM(Z,A,M),tz(Z,A,M))}function IG(A,M){if(A=A.memoizedState,A!==null&&A.dehydrated!==null){var Z=A.retryLane;A.retryLane=Z!==0&&Z<M?Z:M}}function eQ(A,M){IG(A,M),(A=A.alternate)&&IG(A,M)}function e0(A){if(A.tag===13||A.tag===31){var M=eZ(A,67108864);M!==null&&NM(M,A,67108864),eQ(A,67108864)}}function WG(A){if(A.tag===13||A.tag===31){var M=PM();M=GQ(M);var Z=eZ(A,M);Z!==null&&NM(Z,A,M),eQ(A,M)}}var Y3=!0;function kD(A,M,Z,q){var z=f.T;f.T=null;var Y=zA.p;try{zA.p=2,AU(A,M,Z,q)}finally{zA.p=Y,f.T=z}}function CD(A,M,Z,q){var z=f.T;f.T=null;var Y=zA.p;try{zA.p=8,AU(A,M,Z,q)}finally{zA.p=Y,f.T=z}}function AU(A,M,Z,q){if(Y3){var z=YQ(q);if(z===null)Q2(A,M,q,V3,Z),JG(A,q);else if(SD(z,A,M,Z,q))q.stopPropagation();else if(JG(A,q),M&4&&-1<bD.indexOf(A)){for(;z!==null;){var Y=zz(z);if(Y!==null)switch(Y.tag){case 3:if(Y=Y.stateNode,Y.current.memoizedState.isDehydrated){var V=fZ(Y.pendingLanes);if(V!==0){var Q=Y;Q.pendingLanes|=2;for(Q.entangledLanes|=2;V;){var U=1<<31-SM(V);Q.entanglements[1]|=U,V&=~U}O7(Y),(qA&6)===0&&(n9=CM()+500,SY(0,!1))}}break;case 31:case 13:Q=eZ(Y,2),Q!==null&&NM(Q,Y,2),X3(),eQ(Y,2)}if(Y=YQ(q),Y===null&&Q2(A,M,q,V3,Z),Y===z)break;z=Y}z!==null&&q.stopPropagation()}else Q2(A,M,q,null,Z)}}function YQ(A){return A=TQ(A),MU(A)}var V3=null;function MU(A){if(V3=null,A=bq(A),A!==null){var M=EY(A);if(M===null)A=null;else{var Z=M.tag;if(Z===13){if(A=XG(M),A!==null)return A;A=null}else if(Z===31){if(A=OG(M),A!==null)return A;A=null}else if(Z===3){if(M.stateNode.current.memoizedState.isDehydrated)return M.tag===3?M.stateNode.containerInfo:null;A=null}else M!==A&&(A=null)}}return V3=A,null}function AW(A){switch(A){case"beforetoggle":case"cancel":case"click":case"close":case"contextmenu":case"copy":case"cut":case"auxclick":case"dblclick":case"dragend":case"dragstart":case"drop":case"focusin":case"focusout":case"input":case"invalid":case"keydown":case"keypress":case"keyup":case"mousedown":case"mouseup":case"paste":case"pause":case"play":case"pointercancel":case"pointerdown":case"pointerup":case"ratechange":case"reset":case"resize":case"seeked":case"submit":case"toggle":case"touchcancel":case"touchend":case"touchstart":case"volumechange":case"change":case"selectionchange":case"textInput":case"compositionstart":case"compositionend":case"compositionupdate":case"beforeblur":case"afterblur":case"beforeinput":case"blur":case"fullscreenchange":case"focus":case"hashchange":case"popstate":case"select":case"selectstart":return 2;case"drag":case"dragenter":case"dragexit":case"dragleave":case"dragover":case"mousemove":case"mouseout":case"mouseover":case"pointermove":case"pointerout":case"pointerover":case"scroll":case"touchmove":case"wheel":case"mouseenter":case"mouseleave":case"pointerenter":case"pointerleave":return 8;case"message":switch(DK()){case FG:return 2;case LG:return 8;case v9:case NK:return 32;case wG:return 268435456;default:return 32}default:return 32}}var VQ=!1,NZ=null,jZ=null,XZ=null,XY=new Map,OY=new Map,YZ=[],bD="mousedown mouseup touchcancel touchend touchstart auxclick dblclick pointercancel pointerdown pointerup dragend dragstart drop compositionend compositionstart keydown keypress keyup input textInput copy cut paste click change contextmenu reset".split(" ");function JG(A,M){switch(A){case"focusin":case"focusout":NZ=null;break;case"dragenter":case"dragleave":jZ=null;break;case"mouseover":case"mouseout":XZ=null;break;case"pointerover":case"pointerout":XY.delete(M.pointerId);break;case"gotpointercapture":case"lostpointercapture":OY.delete(M.pointerId)}}function uz(A,M,Z,q,z,Y){if(A===null||A.nativeEvent!==Y)return A={blockedOn:M,domEventName:Z,eventSystemFlags:q,nativeEvent:Y,targetContainers:[z]},M!==null&&(M=zz(M),M!==null&&e0(M)),A;return A.eventSystemFlags|=q,M=A.targetContainers,z!==null&&M.indexOf(z)===-1&&M.push(z),A}function SD(A,M,Z,q,z){switch(M){case"focusin":return NZ=uz(NZ,A,M,Z,q,z),!0;case"dragenter":return jZ=uz(jZ,A,M,Z,q,z),!0;case"mouseover":return XZ=uz(XZ,A,M,Z,q,z),!0;case"pointerover":var Y=z.pointerId;return XY.set(Y,uz(XY.get(Y)||null,A,M,Z,q,z)),!0;case"gotpointercapture":return Y=z.pointerId,OY.set(Y,uz(OY.get(Y)||null,A,M,Z,q,z)),!0}return!1}function MW(A){var M=bq(A.target);if(M!==null){var Z=EY(M);if(Z!==null){if(M=Z.tag,M===13){if(M=XG(Z),M!==null){A.blockedOn=M,t1(A.priority,function(){WG(Z)});return}}else if(M===31){if(M=OG(Z),M!==null){A.blockedOn=M,t1(A.priority,function(){WG(Z)});return}}else if(M===3&&Z.stateNode.current.memoizedState.isDehydrated){A.blockedOn=Z.tag===3?Z.stateNode.containerInfo:null;return}}}A.blockedOn=null}function P9(A){if(A.blockedOn!==null)return!1;for(var M=A.targetContainers;0<M.length;){var Z=YQ(A.nativeEvent);if(Z===null){Z=A.nativeEvent;var q=new Z.constructor(Z.type,Z);R2=q,Z.target.dispatchEvent(q),R2=null}else return M=zz(Z),M!==null&&e0(M),A.blockedOn=Z,!1;M.shift()}return!0}function TG(A,M,Z){P9(A)&&Z.delete(M)}function PD(){VQ=!1,NZ!==null&&P9(NZ)&&(NZ=null),jZ!==null&&P9(jZ)&&(jZ=null),XZ!==null&&P9(XZ)&&(XZ=null),XY.forEach(TG),OY.forEach(TG)}function T9(A,M){A.blockedOn===M&&(A.blockedOn=null,VQ||(VQ=!0,cA.unstable_scheduleCallback(cA.unstable_NormalPriority,PD)))}var K9=null;function KG(A){K9!==A&&(K9=A,cA.unstable_scheduleCallback(cA.unstable_NormalPriority,function(){K9===A&&(K9=null);for(var M=0;M<A.length;M+=3){var Z=A[M],q=A[M+1],z=A[M+2];if(typeof q!=="function")if(MU(q||Z)===null)continue;else break;var Y=zz(Z);Y!==null&&(A.splice(M,3),M-=3,u2(Y,{pending:!0,data:z,method:Z.method,action:q},q,z))}}))}function Zz(A){function M(U){return T9(U,A)}NZ!==null&&T9(NZ,A),jZ!==null&&T9(jZ,A),XZ!==null&&T9(XZ,A),XY.forEach(M),OY.forEach(M);for(var Z=0;Z<YZ.length;Z++){var q=YZ[Z];q.blockedOn===A&&(q.blockedOn=null)}for(;0<YZ.length&&(Z=YZ[0],Z.blockedOn===null);)MW(Z),Z.blockedOn===null&&YZ.shift();if(Z=(A.ownerDocument||A).$$reactFormReplay,Z!=null)for(q=0;q<Z.length;q+=3){var z=Z[q],Y=Z[q+1],V=z[jM]||null;if(typeof Y==="function")V||KG(Z);else if(V){var Q=null;if(Y&&Y.hasAttribute("formAction")){if(z=Y,V=Y[jM]||null)Q=V.formAction;else if(MU(z)!==null)continue}else Q=V.action;typeof Q==="function"?Z[q+1]=Q:(Z.splice(q,3),q-=3),KG(Z)}}}function ZW(){function A(Y){Y.canIntercept&&Y.info==="react-transition"&&Y.intercept({handler:function(){return new Promise(function(V){return z=V})},focusReset:"manual",scroll:"manual"})}function M(){z!==null&&(z(),z=null),q||setTimeout(Z,20)}function Z(){if(!q&&!navigation.transition){var Y=navigation.currentEntry;Y&&Y.url!=null&&navigation.navigate(Y.url,{state:Y.getState(),info:"react-transition",history:"replace"})}}if(typeof navigation==="object"){var q=!1,z=null;return navigation.addEventListener("navigate",A),navigation.addEventListener("navigatesuccess",M),navigation.addEventListener("navigateerror",M),setTimeout(Z,100),function(){q=!0,navigation.removeEventListener("navigate",A),navigation.removeEventListener("navigatesuccess",M),navigation.removeEventListener("navigateerror",M),z!==null&&(z(),z=null)}}}function ZU(A){this._internalRoot=A}R3.prototype.render=ZU.prototype.render=function(A){var M=this._internalRoot;if(M===null)throw Error(w(409));var Z=M.current,q=PM();t0(Z,q,A,M,null,null)};R3.prototype.unmount=ZU.prototype.unmount=function(){var A=this._internalRoot;if(A!==null){this._internalRoot=null;var M=A.containerInfo;t0(A.current,2,null,A,null,null),X3(),M[qz]=null}};function R3(A){this._internalRoot=A}R3.prototype.unstable_scheduleHydration=function(A){if(A){var M=PG();A={blockedOn:null,target:A,priority:M};for(var Z=0;Z<YZ.length&&M!==0&&M<YZ[Z].priority;Z++);YZ.splice(Z,0,A),Z===0&&MW(A)}};var DG=NG.version;if(DG!=="19.2.8")throw Error(w(527,DG,"19.2.8"));zA.findDOMNode=function(A){var M=A._reactInternals;if(M===void 0){if(typeof A.render==="function")throw Error(w(188));throw A=Object.keys(A).join(","),Error(w(268,A))}return A=BK(M),A=A!==null?EG(A):null,A=A===null?null:A.stateNode,A};var xD={bundleType:0,version:"19.2.8",rendererPackageName:"react-dom",currentDispatcherRef:f,reconcilerVersion:"19.2.8"};if(typeof __REACT_DEVTOOLS_GLOBAL_HOOK__<"u"){if(wq=__REACT_DEVTOOLS_GLOBAL_HOOK__,!wq.isDisabled&&wq.supportsFiber)try{RY=wq.inject(xD),bM=wq}catch(A){}}var wq;H3.createRoot=function(A,M){if(!jG(A))throw Error(w(299));var Z=!1,q="",z=oI,Y=aI,V=nI;return M!==null&&M!==void 0&&(M.unstable_strictMode===!0&&(Z=!0),M.identifierPrefix!==void 0&&(q=M.identifierPrefix),M.onUncaughtError!==void 0&&(z=M.onUncaughtError),M.onCaughtError!==void 0&&(Y=M.onCaughtError),M.onRecoverableError!==void 0&&(V=M.onRecoverableError)),M=$0(A,1,!1,null,null,Z,q,null,z,Y,V,ZW),A[qz]=M.current,$Q(A),new ZU(M)};H3.hydrateRoot=function(A,M,Z){if(!jG(A))throw Error(w(299));var q=!1,z="",Y=oI,V=aI,Q=nI,U=null;return Z!==null&&Z!==void 0&&(Z.unstable_strictMode===!0&&(q=!0),Z.identifierPrefix!==void 0&&(z=Z.identifierPrefix),Z.onUncaughtError!==void 0&&(Y=Z.onUncaughtError),Z.onCaughtError!==void 0&&(V=Z.onCaughtError),Z.onRecoverableError!==void 0&&(Q=Z.onRecoverableError),Z.formState!==void 0&&(U=Z.formState)),M=$0(A,1,!0,M,Z!=null?Z:null,q,z,U,Y,V,Q,ZW),M.context=_0(null),Z=M.current,q=PM(),q=GQ(q),z=JZ(q),z.callback=null,TZ(Z,z,q),Z=q,M.current.lanes=Z,FY(M,Z),O7(M),A[qz]=M.current,$Q(A),new R3(M)};H3.version="19.2.8"});var VW=J7((xO,YW)=>{function zW(){if(typeof __REACT_DEVTOOLS_GLOBAL_HOOK__>"u"||typeof __REACT_DEVTOOLS_GLOBAL_HOOK__.checkDCE!=="function")return;try{__REACT_DEVTOOLS_GLOBAL_HOOK__.checkDCE(zW)}catch(A){console.error(A)}}zW(),YW.exports=qW()});var dW=J7((C3)=>{var bN=Symbol.for("react.transitional.element"),SN=Symbol.for("react.fragment");function mW(A,M,Z){var q=null;if(Z!==void 0&&(q=""+Z),M.key!==void 0&&(q=""+M.key),"key"in M){Z={};for(var z in M)z!=="key"&&(Z[z]=M[z])}else Z=M;return M=Z.ref,{$$typeof:bN,type:A,key:q,ref:M!==void 0?M:null,props:Z}}C3.Fragment=SN;C3.jsx=mW;C3.jsxs=mW});var uA=J7((iO,pW)=>{pW.exports=dW()});var HO=y(l(),1),fT=y(VW(),1);var n=y(l(),1);var cW=y(l(),1);var MM=y(l(),1);var QW=y(l(),1),yD=Object.defineProperty,zU=(A,M)=>yD(A,"name",{value:M,configurable:!0});function qU(A,M){if(typeof A==="function")return A(M);else if(A!==null&&A!==void 0)A.current=M}zU(qU,"setRef");function UW(...A){return(M)=>{let Z=!1,q=A.map((z)=>{let Y=qU(z,M);if(!Z&&typeof Y=="function")Z=!0;return Y});if(Z)return()=>{for(let z=0;z<q.length;z++){let Y=q[z];if(typeof Y=="function")Y();else qU(A[z],null)}}}}zU(UW,"composeRefs");function IA(...A){return QW.useCallback(UW(...A),A)}zU(IA,"useComposedRefs");var hD=Object.defineProperty,q7=(A,M)=>hD(A,"name",{value:M,configurable:!0});function nM(A){let M=MM.forwardRef((Z,q)=>{let{children:z,...Y}=Z,V=null,Q=!1,U=[];if(YU(z)&&typeof F3==="function")z=F3(z._payload);if(MM.Children.forEach(z,(I)=>{if(JW(I)){Q=!0;let K=I,N="child"in K.props?K.props.child:K.props.children;if(YU(N)&&typeof F3==="function")N=F3(N._payload);V=fD(K,N),U.push(V?.props?.children)}else U.push(I)}),V)V=MM.cloneElement(V,void 0,U);else if(!Q&&MM.Children.count(z)===1&&MM.isValidElement(z))V=z;let B=V?WW(V):void 0,W=IA(q,B);if(!V){if(z||z===0)throw Error(Q?mD(A):uD(A));return z}let J=IW(Y,V.props??{});if(V.type!==MM.Fragment)J.ref=q?W:B;return MM.cloneElement(V,J)});return M.displayName=`${A}.Slot`,M}q7(nM,"createSlot");var BW=nM("Slot"),GW=Symbol.for("radix.slottable");function vD(A){let M=q7((Z)=>("child"in Z)?Z.children(Z.child):Z.children,"Slottable");return M.displayName=`${A}.Slottable`,M.__radixId=GW,M}q7(vD,"createSlottable");var fD=q7((A,M)=>{if("child"in A.props){let Z=A.props.child;if(!MM.isValidElement(Z))return null;return MM.cloneElement(Z,void 0,A.props.children(Z.props.children))}return MM.isValidElement(M)?M:null},"getSlottableElementFromSlottable");function IW(A,M){let Z={...M};for(let q in M){let z=A[q],Y=M[q];if(/^on[A-Z]/.test(q)){if(z&&Y)Z[q]=(...Q)=>{let U=Y(...Q);return z(...Q),U};else if(z)Z[q]=z}else if(q==="style")Z[q]={...z,...Y};else if(q==="className")Z[q]=[z,Y].filter(Boolean).join(" ")}return{...A,...Z}}q7(IW,"mergeProps");function WW(A){let M=Object.getOwnPropertyDescriptor(A.props,"ref")?.get,Z=M&&"isReactWarning"in M&&M.isReactWarning;if(Z)return A.ref;if(M=Object.getOwnPropertyDescriptor(A,"ref")?.get,Z=M&&"isReactWarning"in M&&M.isReactWarning,Z)return A.props.ref;return A.props.ref||A.ref}q7(WW,"getElementRef");function JW(A){return MM.isValidElement(A)&&typeof A.type==="function"&&"__radixId"in A.type&&A.type.__radixId===GW}q7(JW,"isSlottable");var gD=Symbol.for("react.lazy");function YU(A){return A!=null&&typeof A==="object"&&"$$typeof"in A&&A.$$typeof===gD&&"_payload"in A&&TW(A._payload)}q7(YU,"isLazyComponent");function TW(A){return typeof A==="object"&&A!==null&&"then"in A}q7(TW,"isPromiseLike");var uD=q7((A)=>{return`${A} failed to slot onto its children. Expected a single React element child or \`Slottable\`.`},"createSlotError"),mD=q7((A)=>{return`${A} failed to slot onto its \`Slottable\`. Expected \`Slottable\` to receive a single React element child.`},"createSlottableError"),F3=MM[" use ".trim().toString()];function KW(A){var M,Z,q="";if(typeof A=="string"||typeof A=="number")q+=A;else if(typeof A=="object")if(Array.isArray(A)){var z=A.length;for(M=0;M<z;M++)A[M]&&(Z=KW(A[M]))&&(q&&(q+=" "),q+=Z)}else for(Z in A)A[Z]&&(q&&(q+=" "),q+=Z);return q}function L3(){for(var A,M,Z=0,q="",z=arguments.length;Z<z;Z++)(A=arguments[Z])&&(M=KW(A))&&(q&&(q+=" "),q+=M);return q}var DW=(A)=>typeof A==="boolean"?`${A}`:A===0?"0":A,NW=L3,jW=(A,M)=>(Z)=>{var q;if((M===null||M===void 0?void 0:M.variants)==null)return NW(A,Z===null||Z===void 0?void 0:Z.class,Z===null||Z===void 0?void 0:Z.className);let{variants:z,defaultVariants:Y}=M,V=Object.keys(z).map((B)=>{let W=Z===null||Z===void 0?void 0:Z[B],J=Y===null||Y===void 0?void 0:Y[B];if(W===null)return null;let I=DW(W)||DW(J);return z[B][I]}),Q=Z&&Object.entries(Z).reduce((B,W)=>{let[J,I]=W;if(I===void 0)return B;return B[J]=I,B},{}),U=M===null||M===void 0?void 0:(q=M.compoundVariants)===null||q===void 0?void 0:q.reduce((B,W)=>{let{class:J,className:I,...K}=W;return Object.entries(K).every((N)=>{let[O,j]=N;return Array.isArray(j)?j.includes({...Y,...Q}[O]):{...Y,...Q}[O]===j})?[...B,J,I]:B},[]);return NW(A,V,U,Z===null||Z===void 0?void 0:Z.class,Z===null||Z===void 0?void 0:Z.className)};var dD=(A,M)=>{let Z=Array(A.length+M.length);for(let q=0;q<A.length;q++)Z[q]=A[q];for(let q=0;q<M.length;q++)Z[A.length+q]=M[q];return Z},pD=(A,M)=>({classGroupId:A,validator:M}),FW=(A=new Map,M=null,Z)=>({nextPart:A,validators:M,classGroupId:Z});var XW=[];var cD=(A)=>{let M=iD(A),{conflictingClassGroups:Z,conflictingClassGroupModifiers:q}=A;return{getClassGroupId:(V)=>{if(V.startsWith("[")&&V.endsWith("]"))return lD(V);let Q=V.split("-"),U=Q[0]===""&&Q.length>1?1:0;return LW(Q,U,M)},getConflictingClassGroupIds:(V,Q)=>{if(Q){let U=q[V],B=Z[V];if(U){if(B)return dD(B,U);return U}return B||XW}return Z[V]||XW}}},LW=(A,M,Z)=>{if(A.length-M===0)return Z.classGroupId;let z=A[M],Y=Z.nextPart.get(z);if(Y){let B=LW(A,M+1,Y);if(B)return B}let V=Z.validators;if(V===null)return;let Q=M===0?A.join("-"):A.slice(M).join("-"),U=V.length;for(let B=0;B<U;B++){let W=V[B];if(W.validator(Q))return W.classGroupId}return},lD=(A)=>A.slice(1,-1).indexOf(":")===-1?void 0:(()=>{let M=A.slice(1,-1),Z=M.indexOf(":"),q=M.slice(0,Z);return q?"arbitrary.."+q:void 0})(),iD=(A)=>{let{theme:M,classGroups:Z}=A;return rD(Z,M)},rD=(A,M)=>{let Z=FW();for(let q in A){let z=A[q];QU(z,Z,q,M)}return Z},QU=(A,M,Z,q)=>{let z=A.length;for(let Y=0;Y<z;Y++){let V=A[Y];sD(V,M,Z,q)}},sD=(A,M,Z,q)=>{if(typeof A==="string"){oD(A,M,Z);return}if(typeof A==="function"){aD(A,M,Z,q);return}nD(A,M,Z,q)},oD=(A,M,Z)=>{let q=A===""?M:wW(M,A);q.classGroupId=Z},aD=(A,M,Z,q)=>{if($D(A)){QU(A(q),M,Z,q);return}if(M.validators===null)M.validators=[];M.validators.push(pD(Z,A))},nD=(A,M,Z,q)=>{let z=Object.entries(A),Y=z.length;for(let V=0;V<Y;V++){let[Q,U]=z[V];QU(U,wW(M,Q),Z,q)}},wW=(A,M)=>{let Z=A,q=M.split("-"),z=q.length;for(let Y=0;Y<z;Y++){let V=q[Y],Q=Z.nextPart.get(V);if(!Q)Q=FW(),Z.nextPart.set(V,Q);Z=Q}return Z},$D=(A)=>("isThemeGetter"in A)&&A.isThemeGetter===!0,_D=(A)=>{if(A<1)return{get:()=>{return},set:()=>{}};let M=0,Z=Object.create(null),q=Object.create(null),z=(Y,V)=>{if(Z[Y]=V,M++,M>A)M=0,q=Z,Z=Object.create(null)};return{get(Y){let V=Z[Y];if(V!==void 0)return V;if((V=q[Y])!==void 0)return z(Y,V),V},set(Y,V){if(Y in Z)Z[Y]=V;else z(Y,V)}}};var tD=[],OW=(A,M,Z,q,z)=>({modifiers:A,hasImportantModifier:M,baseClassName:Z,maybePostfixModifierPosition:q,isExternal:z}),eD=(A)=>{let{prefix:M,experimentalParseClassName:Z}=A,q=(z)=>{let Y=[],V=0,Q=0,U=0,B,W=z.length;for(let O=0;O<W;O++){let j=z[O];if(V===0&&Q===0){if(j===":"){Y.push(z.slice(U,O)),U=O+1;continue}if(j==="/"){B=O;continue}}if(j==="[")V++;else if(j==="]")V--;else if(j==="(")Q++;else if(j===")")Q--}let J=Y.length===0?z:z.slice(U),I=J,K=!1;if(J.endsWith("!"))I=J.slice(0,-1),K=!0;else if(J.startsWith("!"))I=J.slice(1),K=!0;let N=B&&B>U?B-U:void 0;return OW(Y,K,I,N)};if(M){let z=M+":",Y=q;q=(V)=>V.startsWith(z)?Y(V.slice(z.length)):OW(tD,!1,V,void 0,!0)}if(Z){let z=q;q=(Y)=>Z({className:Y,parseClassName:z})}return q},AN=(A)=>{let M=new Map;return A.orderSensitiveModifiers.forEach((Z,q)=>{M.set(Z,1e6+q)}),(Z)=>{let q=[],z=[];for(let Y=0;Y<Z.length;Y++){let V=Z[Y],Q=V[0]==="[",U=M.has(V);if(Q||U){if(z.length>0)z.sort(),q.push(...z),z=[];q.push(V)}else z.push(V)}if(z.length>0)z.sort(),q.push(...z);return q}},MN=(A)=>({cache:_D(A.cacheSize),parseClassName:eD(A),sortModifiers:AN(A),postfixLookupClassGroupIds:ZN(A),...cD(A)}),ZN=(A)=>{let M=Object.create(null),Z=A.postfixLookupClassGroups;if(Z)for(let q=0;q<Z.length;q++)M[Z[q]]=!0;return M},qN=/\s+/,zN=(A,M)=>{let{parseClassName:Z,getClassGroupId:q,getConflictingClassGroupIds:z,sortModifiers:Y,postfixLookupClassGroupIds:V}=M,Q=[],U=A.trim().split(qN),B="";for(let W=U.length-1;W>=0;W-=1){let J=U[W],{isExternal:I,modifiers:K,hasImportantModifier:N,baseClassName:O,maybePostfixModifierPosition:j}=Z(J);if(I){B=J+(B.length>0?" "+B:B);continue}let T=!!j,G;if(T){let F=O.substring(0,j);G=q(F);let R=G&&V[G]?q(O):void 0;if(R&&R!==G)G=R,T=!1}else G=q(O);if(!G){if(!T){B=J+(B.length>0?" "+B:B);continue}if(G=q(O),!G){B=J+(B.length>0?" "+B:B);continue}T=!1}let D=K.length===0?"":K.length===1?K[0]:Y(K).join(":"),X=N?D+"!":D,H=X+G;if(Q.indexOf(H)>-1)continue;Q.push(H);let L=z(G,T);for(let F=0;F<L.length;++F){let R=L[F];Q.push(X+R)}B=J+(B.length>0?" "+B:B)}return B},YN=(...A)=>{let M=0,Z,q,z="";while(M<A.length)if(Z=A[M++]){if(q=kW(Z))z&&(z+=" "),z+=q}return z},kW=(A)=>{if(typeof A==="string")return A;let M,Z="";for(let q=0;q<A.length;q++)if(A[q]){if(M=kW(A[q]))Z&&(Z+=" "),Z+=M}return Z},VN=(A,...M)=>{let Z,q,z,Y,V=(U)=>{let B=M.reduce((W,J)=>J(W),A());return Z=MN(B),q=Z.cache.get,z=Z.cache.set,Y=Q,Q(U)},Q=(U)=>{let B=q(U);if(B)return B;let W=zN(U,Z);return z(U,W),W};return Y=V,(...U)=>Y(YN(...U))},QN=[],lA=(A)=>{let M=(Z)=>Z[A]||QN;return M.isThemeGetter=!0,M},CW=/^\[(?:(\w[\w-]*):)?(.+)\]$/i,bW=/^\((?:(\w[\w-]*):)?(.+)\)$/i,UN=/^\d+(?:\.\d+)?\/\d+(?:\.\d+)?$/,BN=/^(\d+(\.\d+)?)?(xs|sm|md|lg|xl)$/,GN=/\d+(%|px|r?em|[sdl]?v([hwib]|min|max)|pt|pc|in|cm|mm|cap|ch|ex|r?lh|cq(w|h|i|b|min|max))|\b(calc|min|max|clamp)\(.+\)|^0$/,IN=/^(rgba?|hsla?|hwb|(ok)?(lab|lch)|color-mix)\(.+\)$/,WN=/^(inset_)?-?((\d+)?\.?(\d+)[a-z]+|0)_-?((\d+)?\.?(\d+)[a-z]+|0)/,JN=/^(url|image|image-set|cross-fade|element|(repeating-)?(linear|radial|conic)-gradient)\(.+\)$/,wZ=(A)=>UN.test(A),a=(A)=>!!A&&!Number.isNaN(Number(A)),E7=(A)=>!!A&&Number.isInteger(Number(A)),VU=(A)=>A.endsWith("%")&&a(A.slice(0,-1)),s7=(A)=>BN.test(A),SW=()=>!0,TN=(A)=>GN.test(A)&&!IN.test(A),UU=()=>!1,KN=(A)=>WN.test(A),DN=(A)=>JN.test(A),NN=(A)=>!P(A)&&!x(A),jN=(A)=>A.startsWith("@container")&&(A[10]==="/"&&A[11]!==void 0||A[11]==="s"&&A[16]!==void 0&&A.startsWith("-size/",10)||A[11]==="n"&&A[18]!==void 0&&A.startsWith("-normal/",10)),XN=(A)=>kZ(A,yW,UU),P=(A)=>CW.test(A),Mq=(A)=>kZ(A,hW,TN),EW=(A)=>kZ(A,kN,a),ON=(A)=>kZ(A,fW,SW),EN=(A)=>kZ(A,vW,UU),RW=(A)=>kZ(A,PW,UU),RN=(A)=>kZ(A,xW,DN),w3=(A)=>kZ(A,gW,KN),x=(A)=>bW.test(A),yY=(A)=>Zq(A,hW),HN=(A)=>Zq(A,vW),HW=(A)=>Zq(A,PW),FN=(A)=>Zq(A,yW),LN=(A)=>Zq(A,xW),k3=(A)=>Zq(A,gW,!0),wN=(A)=>Zq(A,fW,!0),kZ=(A,M,Z)=>{let q=CW.exec(A);if(q){if(q[1])return M(q[1]);return Z(q[2])}return!1},Zq=(A,M,Z=!1)=>{let q=bW.exec(A);if(q){if(q[1])return M(q[1]);return Z}return!1},PW=(A)=>A==="position"||A==="percentage",xW=(A)=>A==="image"||A==="url",yW=(A)=>A==="length"||A==="size"||A==="bg-size",hW=(A)=>A==="length",kN=(A)=>A==="number",vW=(A)=>A==="family-name",fW=(A)=>A==="number"||A==="weight",gW=(A)=>A==="shadow";var CN=()=>{let A=lA("color"),M=lA("font"),Z=lA("text"),q=lA("font-weight"),z=lA("tracking"),Y=lA("leading"),V=lA("breakpoint"),Q=lA("container"),U=lA("spacing"),B=lA("radius"),W=lA("shadow"),J=lA("inset-shadow"),I=lA("text-shadow"),K=lA("drop-shadow"),N=lA("blur"),O=lA("perspective"),j=lA("aspect"),T=lA("ease"),G=lA("animate"),D=()=>["auto","avoid","all","avoid-page","page","left","right","column"],X=()=>["center","top","bottom","left","right","top-left","left-top","top-right","right-top","bottom-right","right-bottom","bottom-left","left-bottom"],H=()=>[...X(),x,P],L=()=>["auto","hidden","clip","visible","scroll"],F=()=>["auto","contain","none"],R=()=>[x,P,U],k=()=>[wZ,"full","auto",...R()],b=()=>[E7,"none","subgrid",x,P],u=()=>["auto",{span:["full",E7,x,P]},E7,x,P],h=()=>[E7,"auto",x,P],p=()=>["auto","min","max","fr",x,P],o=()=>["start","end","center","between","around","evenly","stretch","baseline","center-safe","end-safe"],MA=()=>["start","end","center","stretch","center-safe","end-safe"],g=()=>["auto",...R()],i=()=>[wZ,"auto","full","dvw","dvh","lvw","lvh","svw","svh","min","max","fit",...R()],m=()=>[wZ,"screen","full","dvw","lvw","svw","min","max","fit",...R()],ZA=()=>[wZ,"screen","full","lh","dvh","lvh","svh","min","max","fit",...R()],S=()=>[A,x,P],hM=()=>[...X(),HW,RW,{position:[x,P]}],yA=()=>["no-repeat",{repeat:["","x","y","space","round"]}],qM=()=>["auto","cover","contain",FN,XN,{size:[x,P]}],vM=()=>[VU,yY,Mq],EA=()=>["","none","full",B,x,P],kA=()=>["",a,yY,Mq],fM=()=>["solid","dashed","dotted","double"],d=()=>["normal","multiply","screen","overlay","darken","lighten","color-dodge","color-burn","hard-light","soft-light","difference","exclusion","hue","saturation","color","luminosity"],r=()=>[a,VU,HW,RW],dA=()=>["","none",N,x,P],YA=()=>["none",a,x,P],VA=()=>["none",a,x,P],RA=()=>[a,x,P],WM=()=>[wZ,"full",...R()];return{cacheSize:500,theme:{animate:["spin","ping","pulse","bounce"],aspect:["video"],blur:[s7],breakpoint:[s7],color:[SW],container:[s7],"drop-shadow":[s7],ease:["in","out","in-out"],font:[NN],"font-weight":["thin","extralight","light","normal","medium","semibold","bold","extrabold","black"],"inset-shadow":[s7],leading:["none","tight","snug","normal","relaxed","loose"],perspective:["dramatic","near","normal","midrange","distant","none"],radius:[s7],shadow:[s7],spacing:["px",a],text:[s7],"text-shadow":[s7],tracking:["tighter","tight","normal","wide","wider","widest"]},classGroups:{aspect:[{aspect:["auto","square",wZ,P,x,j]}],container:["container"],"container-type":[{"@container":["","normal","size",x,P]}],"container-named":[jN],columns:[{columns:[a,P,x,Q]}],"break-after":[{"break-after":D()}],"break-before":[{"break-before":D()}],"break-inside":[{"break-inside":["auto","avoid","avoid-page","avoid-column"]}],"box-decoration":[{"box-decoration":["slice","clone"]}],box:[{box:["border","content"]}],display:["block","inline-block","inline","flex","inline-flex","table","inline-table","table-caption","table-cell","table-column","table-column-group","table-footer-group","table-header-group","table-row-group","table-row","flow-root","grid","inline-grid","contents","list-item","hidden"],sr:["sr-only","not-sr-only"],float:[{float:["right","left","none","start","end"]}],clear:[{clear:["left","right","both","none","start","end"]}],isolation:["isolate","isolation-auto"],"object-fit":[{object:["contain","cover","fill","none","scale-down"]}],"object-position":[{object:H()}],overflow:[{overflow:L()}],"overflow-x":[{"overflow-x":L()}],"overflow-y":[{"overflow-y":L()}],overscroll:[{overscroll:F()}],"overscroll-x":[{"overscroll-x":F()}],"overscroll-y":[{"overscroll-y":F()}],position:["static","fixed","absolute","relative","sticky"],inset:[{inset:k()}],"inset-x":[{"inset-x":k()}],"inset-y":[{"inset-y":k()}],start:[{"inset-s":k(),start:k()}],end:[{"inset-e":k(),end:k()}],"inset-bs":[{"inset-bs":k()}],"inset-be":[{"inset-be":k()}],top:[{top:k()}],right:[{right:k()}],bottom:[{bottom:k()}],left:[{left:k()}],visibility:["visible","invisible","collapse"],z:[{z:[E7,"auto",x,P]}],basis:[{basis:[wZ,"full","auto",Q,...R()]}],"flex-direction":[{flex:["row","row-reverse","col","col-reverse"]}],"flex-wrap":[{flex:["nowrap","wrap","wrap-reverse"]}],flex:[{flex:[a,wZ,"auto","initial","none",P]}],grow:[{grow:["",a,x,P]}],shrink:[{shrink:["",a,x,P]}],order:[{order:[E7,"first","last","none",x,P]}],"grid-cols":[{"grid-cols":b()}],"col-start-end":[{col:u()}],"col-start":[{"col-start":h()}],"col-end":[{"col-end":h()}],"grid-rows":[{"grid-rows":b()}],"row-start-end":[{row:u()}],"row-start":[{"row-start":h()}],"row-end":[{"row-end":h()}],"grid-flow":[{"grid-flow":["row","col","dense","row-dense","col-dense"]}],"auto-cols":[{"auto-cols":p()}],"auto-rows":[{"auto-rows":p()}],gap:[{gap:R()}],"gap-x":[{"gap-x":R()}],"gap-y":[{"gap-y":R()}],"justify-content":[{justify:[...o(),"normal"]}],"justify-items":[{"justify-items":[...MA(),"normal"]}],"justify-self":[{"justify-self":["auto",...MA()]}],"align-content":[{content:["normal",...o()]}],"align-items":[{items:[...MA(),{baseline:["","last"]}]}],"align-self":[{self:["auto",...MA(),{baseline:["","last"]}]}],"place-content":[{"place-content":o()}],"place-items":[{"place-items":[...MA(),"baseline"]}],"place-self":[{"place-self":["auto",...MA()]}],p:[{p:R()}],px:[{px:R()}],py:[{py:R()}],ps:[{ps:R()}],pe:[{pe:R()}],pbs:[{pbs:R()}],pbe:[{pbe:R()}],pt:[{pt:R()}],pr:[{pr:R()}],pb:[{pb:R()}],pl:[{pl:R()}],m:[{m:g()}],mx:[{mx:g()}],my:[{my:g()}],ms:[{ms:g()}],me:[{me:g()}],mbs:[{mbs:g()}],mbe:[{mbe:g()}],mt:[{mt:g()}],mr:[{mr:g()}],mb:[{mb:g()}],ml:[{ml:g()}],"space-x":[{"space-x":R()}],"space-x-reverse":["space-x-reverse"],"space-y":[{"space-y":R()}],"space-y-reverse":["space-y-reverse"],size:[{size:i()}],"inline-size":[{inline:["auto",...m()]}],"min-inline-size":[{"min-inline":["auto",...m()]}],"max-inline-size":[{"max-inline":["none",...m()]}],"block-size":[{block:["auto",...ZA()]}],"min-block-size":[{"min-block":["auto",...ZA()]}],"max-block-size":[{"max-block":["none",...ZA()]}],w:[{w:[Q,"screen",...i()]}],"min-w":[{"min-w":[Q,"screen","none",...i()]}],"max-w":[{"max-w":[Q,"screen","none","prose",{screen:[V]},...i()]}],h:[{h:["screen","lh",...i()]}],"min-h":[{"min-h":["screen","lh","none",...i()]}],"max-h":[{"max-h":["screen","lh",...i()]}],"font-size":[{text:["base",Z,yY,Mq]}],"font-smoothing":["antialiased","subpixel-antialiased"],"font-style":["italic","not-italic"],"font-weight":[{font:[q,wN,ON]}],"font-stretch":[{"font-stretch":["ultra-condensed","extra-condensed","condensed","semi-condensed","normal","semi-expanded","expanded","extra-expanded","ultra-expanded",VU,P]}],"font-family":[{font:[HN,EN,M]}],"font-features":[{"font-features":[P]}],"fvn-normal":["normal-nums"],"fvn-ordinal":["ordinal"],"fvn-slashed-zero":["slashed-zero"],"fvn-figure":["lining-nums","oldstyle-nums"],"fvn-spacing":["proportional-nums","tabular-nums"],"fvn-fraction":["diagonal-fractions","stacked-fractions"],tracking:[{tracking:[z,x,P]}],"line-clamp":[{"line-clamp":[a,"none",x,EW]}],leading:[{leading:[Y,...R()]}],"list-image":[{"list-image":["none",x,P]}],"list-style-position":[{list:["inside","outside"]}],"list-style-type":[{list:["disc","decimal","none",x,P]}],"text-alignment":[{text:["left","center","right","justify","start","end"]}],"placeholder-color":[{placeholder:S()}],"text-color":[{text:S()}],"text-decoration":["underline","overline","line-through","no-underline"],"text-decoration-style":[{decoration:[...fM(),"wavy"]}],"text-decoration-thickness":[{decoration:[a,"from-font","auto",x,Mq]}],"text-decoration-color":[{decoration:S()}],"underline-offset":[{"underline-offset":[a,"auto",x,P]}],"text-transform":["uppercase","lowercase","capitalize","normal-case"],"text-overflow":["truncate","text-ellipsis","text-clip"],"text-wrap":[{text:["wrap","nowrap","balance","pretty"]}],indent:[{indent:R()}],"tab-size":[{tab:[E7,x,P]}],"vertical-align":[{align:["baseline","top","middle","bottom","text-top","text-bottom","sub","super",x,P]}],whitespace:[{whitespace:["normal","nowrap","pre","pre-line","pre-wrap","break-spaces"]}],break:[{break:["normal","words","all","keep"]}],wrap:[{wrap:["break-word","anywhere","normal"]}],hyphens:[{hyphens:["none","manual","auto"]}],content:[{content:["none",x,P]}],"bg-attachment":[{bg:["fixed","local","scroll"]}],"bg-clip":[{"bg-clip":["border","padding","content","text"]}],"bg-origin":[{"bg-origin":["border","padding","content"]}],"bg-position":[{bg:hM()}],"bg-repeat":[{bg:yA()}],"bg-size":[{bg:qM()}],"bg-image":[{bg:["none",{linear:[{to:["t","tr","r","br","b","bl","l","tl"]},E7,x,P],radial:["",x,P],conic:[E7,x,P]},LN,RN]}],"bg-color":[{bg:S()}],"gradient-from-pos":[{from:vM()}],"gradient-via-pos":[{via:vM()}],"gradient-to-pos":[{to:vM()}],"gradient-from":[{from:S()}],"gradient-via":[{via:S()}],"gradient-to":[{to:S()}],rounded:[{rounded:EA()}],"rounded-s":[{"rounded-s":EA()}],"rounded-e":[{"rounded-e":EA()}],"rounded-t":[{"rounded-t":EA()}],"rounded-r":[{"rounded-r":EA()}],"rounded-b":[{"rounded-b":EA()}],"rounded-l":[{"rounded-l":EA()}],"rounded-ss":[{"rounded-ss":EA()}],"rounded-se":[{"rounded-se":EA()}],"rounded-ee":[{"rounded-ee":EA()}],"rounded-es":[{"rounded-es":EA()}],"rounded-tl":[{"rounded-tl":EA()}],"rounded-tr":[{"rounded-tr":EA()}],"rounded-br":[{"rounded-br":EA()}],"rounded-bl":[{"rounded-bl":EA()}],"border-w":[{border:kA()}],"border-w-x":[{"border-x":kA()}],"border-w-y":[{"border-y":kA()}],"border-w-s":[{"border-s":kA()}],"border-w-e":[{"border-e":kA()}],"border-w-bs":[{"border-bs":kA()}],"border-w-be":[{"border-be":kA()}],"border-w-t":[{"border-t":kA()}],"border-w-r":[{"border-r":kA()}],"border-w-b":[{"border-b":kA()}],"border-w-l":[{"border-l":kA()}],"divide-x":[{"divide-x":kA()}],"divide-x-reverse":["divide-x-reverse"],"divide-y":[{"divide-y":kA()}],"divide-y-reverse":["divide-y-reverse"],"border-style":[{border:[...fM(),"hidden","none"]}],"divide-style":[{divide:[...fM(),"hidden","none"]}],"border-color":[{border:S()}],"border-color-x":[{"border-x":S()}],"border-color-y":[{"border-y":S()}],"border-color-s":[{"border-s":S()}],"border-color-e":[{"border-e":S()}],"border-color-bs":[{"border-bs":S()}],"border-color-be":[{"border-be":S()}],"border-color-t":[{"border-t":S()}],"border-color-r":[{"border-r":S()}],"border-color-b":[{"border-b":S()}],"border-color-l":[{"border-l":S()}],"divide-color":[{divide:S()}],"outline-style":[{outline:[...fM(),"none","hidden"]}],"outline-offset":[{"outline-offset":[a,x,P]}],"outline-w":[{outline:["",a,yY,Mq]}],"outline-color":[{outline:S()}],shadow:[{shadow:["","none",W,k3,w3]}],"shadow-color":[{shadow:S()}],"inset-shadow":[{"inset-shadow":["none",J,k3,w3]}],"inset-shadow-color":[{"inset-shadow":S()}],"ring-w":[{ring:kA()}],"ring-w-inset":["ring-inset"],"ring-color":[{ring:S()}],"ring-offset-w":[{"ring-offset":[a,Mq]}],"ring-offset-color":[{"ring-offset":S()}],"inset-ring-w":[{"inset-ring":kA()}],"inset-ring-color":[{"inset-ring":S()}],"text-shadow":[{"text-shadow":["none",I,k3,w3]}],"text-shadow-color":[{"text-shadow":S()}],opacity:[{opacity:[a,x,P]}],"mix-blend":[{"mix-blend":[...d(),"plus-darker","plus-lighter"]}],"bg-blend":[{"bg-blend":d()}],"mask-clip":[{"mask-clip":["border","padding","content","fill","stroke","view"]},"mask-no-clip"],"mask-composite":[{mask:["add","subtract","intersect","exclude"]}],"mask-image-linear-pos":[{"mask-linear":[a]}],"mask-image-linear-from-pos":[{"mask-linear-from":r()}],"mask-image-linear-to-pos":[{"mask-linear-to":r()}],"mask-image-linear-from-color":[{"mask-linear-from":S()}],"mask-image-linear-to-color":[{"mask-linear-to":S()}],"mask-image-t-from-pos":[{"mask-t-from":r()}],"mask-image-t-to-pos":[{"mask-t-to":r()}],"mask-image-t-from-color":[{"mask-t-from":S()}],"mask-image-t-to-color":[{"mask-t-to":S()}],"mask-image-r-from-pos":[{"mask-r-from":r()}],"mask-image-r-to-pos":[{"mask-r-to":r()}],"mask-image-r-from-color":[{"mask-r-from":S()}],"mask-image-r-to-color":[{"mask-r-to":S()}],"mask-image-b-from-pos":[{"mask-b-from":r()}],"mask-image-b-to-pos":[{"mask-b-to":r()}],"mask-image-b-from-color":[{"mask-b-from":S()}],"mask-image-b-to-color":[{"mask-b-to":S()}],"mask-image-l-from-pos":[{"mask-l-from":r()}],"mask-image-l-to-pos":[{"mask-l-to":r()}],"mask-image-l-from-color":[{"mask-l-from":S()}],"mask-image-l-to-color":[{"mask-l-to":S()}],"mask-image-x-from-pos":[{"mask-x-from":r()}],"mask-image-x-to-pos":[{"mask-x-to":r()}],"mask-image-x-from-color":[{"mask-x-from":S()}],"mask-image-x-to-color":[{"mask-x-to":S()}],"mask-image-y-from-pos":[{"mask-y-from":r()}],"mask-image-y-to-pos":[{"mask-y-to":r()}],"mask-image-y-from-color":[{"mask-y-from":S()}],"mask-image-y-to-color":[{"mask-y-to":S()}],"mask-image-radial":[{"mask-radial":[x,P]}],"mask-image-radial-from-pos":[{"mask-radial-from":r()}],"mask-image-radial-to-pos":[{"mask-radial-to":r()}],"mask-image-radial-from-color":[{"mask-radial-from":S()}],"mask-image-radial-to-color":[{"mask-radial-to":S()}],"mask-image-radial-shape":[{"mask-radial":["circle","ellipse"]}],"mask-image-radial-size":[{"mask-radial":[{closest:["side","corner"],farthest:["side","corner"]}]}],"mask-image-radial-pos":[{"mask-radial-at":X()}],"mask-image-conic-pos":[{"mask-conic":[a]}],"mask-image-conic-from-pos":[{"mask-conic-from":r()}],"mask-image-conic-to-pos":[{"mask-conic-to":r()}],"mask-image-conic-from-color":[{"mask-conic-from":S()}],"mask-image-conic-to-color":[{"mask-conic-to":S()}],"mask-mode":[{mask:["alpha","luminance","match"]}],"mask-origin":[{"mask-origin":["border","padding","content","fill","stroke","view"]}],"mask-position":[{mask:hM()}],"mask-repeat":[{mask:yA()}],"mask-size":[{mask:qM()}],"mask-type":[{"mask-type":["alpha","luminance"]}],"mask-image":[{mask:["none",x,P]}],filter:[{filter:["","none",x,P]}],blur:[{blur:dA()}],brightness:[{brightness:[a,x,P]}],contrast:[{contrast:[a,x,P]}],"drop-shadow":[{"drop-shadow":["","none",K,k3,w3]}],"drop-shadow-color":[{"drop-shadow":S()}],grayscale:[{grayscale:["",a,x,P]}],"hue-rotate":[{"hue-rotate":[a,x,P]}],invert:[{invert:["",a,x,P]}],saturate:[{saturate:[a,x,P]}],sepia:[{sepia:["",a,x,P]}],"backdrop-filter":[{"backdrop-filter":["","none",x,P]}],"backdrop-blur":[{"backdrop-blur":dA()}],"backdrop-brightness":[{"backdrop-brightness":[a,x,P]}],"backdrop-contrast":[{"backdrop-contrast":[a,x,P]}],"backdrop-grayscale":[{"backdrop-grayscale":["",a,x,P]}],"backdrop-hue-rotate":[{"backdrop-hue-rotate":[a,x,P]}],"backdrop-invert":[{"backdrop-invert":["",a,x,P]}],"backdrop-opacity":[{"backdrop-opacity":[a,x,P]}],"backdrop-saturate":[{"backdrop-saturate":[a,x,P]}],"backdrop-sepia":[{"backdrop-sepia":["",a,x,P]}],"border-collapse":[{border:["collapse","separate"]}],"border-spacing":[{"border-spacing":R()}],"border-spacing-x":[{"border-spacing-x":R()}],"border-spacing-y":[{"border-spacing-y":R()}],"table-layout":[{table:["auto","fixed"]}],caption:[{caption:["top","bottom"]}],transition:[{transition:["","all","colors","opacity","shadow","transform","none",x,P]}],"transition-behavior":[{transition:["normal","discrete"]}],duration:[{duration:[a,"initial",x,P]}],ease:[{ease:["linear","initial",T,x,P]}],delay:[{delay:[a,x,P]}],animate:[{animate:["none",G,x,P]}],backface:[{backface:["hidden","visible"]}],perspective:[{perspective:[O,x,P]}],"perspective-origin":[{"perspective-origin":H()}],rotate:[{rotate:YA()}],"rotate-x":[{"rotate-x":YA()}],"rotate-y":[{"rotate-y":YA()}],"rotate-z":[{"rotate-z":YA()}],scale:[{scale:VA()}],"scale-x":[{"scale-x":VA()}],"scale-y":[{"scale-y":VA()}],"scale-z":[{"scale-z":VA()}],"scale-3d":["scale-3d"],skew:[{skew:RA()}],"skew-x":[{"skew-x":RA()}],"skew-y":[{"skew-y":RA()}],transform:[{transform:[x,P,"","none","gpu","cpu"]}],"transform-origin":[{origin:H()}],"transform-style":[{transform:["3d","flat"]}],translate:[{translate:WM()}],"translate-x":[{"translate-x":WM()}],"translate-y":[{"translate-y":WM()}],"translate-z":[{"translate-z":WM()}],"translate-none":["translate-none"],zoom:[{zoom:[E7,x,P]}],accent:[{accent:S()}],appearance:[{appearance:["none","auto"]}],"caret-color":[{caret:S()}],"color-scheme":[{scheme:["normal","dark","light","light-dark","only-dark","only-light"]}],cursor:[{cursor:["auto","default","pointer","wait","text","move","help","not-allowed","none","context-menu","progress","cell","crosshair","vertical-text","alias","copy","no-drop","grab","grabbing","all-scroll","col-resize","row-resize","n-resize","e-resize","s-resize","w-resize","ne-resize","nw-resize","se-resize","sw-resize","ew-resize","ns-resize","nesw-resize","nwse-resize","zoom-in","zoom-out",x,P]}],"field-sizing":[{"field-sizing":["fixed","content"]}],"pointer-events":[{"pointer-events":["auto","none"]}],resize:[{resize:["none","","y","x"]}],"scroll-behavior":[{scroll:["auto","smooth"]}],"scrollbar-thumb-color":[{"scrollbar-thumb":S()}],"scrollbar-track-color":[{"scrollbar-track":S()}],"scrollbar-gutter":[{"scrollbar-gutter":["auto","stable","both"]}],"scrollbar-w":[{scrollbar:["auto","thin","none"]}],"scroll-m":[{"scroll-m":R()}],"scroll-mx":[{"scroll-mx":R()}],"scroll-my":[{"scroll-my":R()}],"scroll-ms":[{"scroll-ms":R()}],"scroll-me":[{"scroll-me":R()}],"scroll-mbs":[{"scroll-mbs":R()}],"scroll-mbe":[{"scroll-mbe":R()}],"scroll-mt":[{"scroll-mt":R()}],"scroll-mr":[{"scroll-mr":R()}],"scroll-mb":[{"scroll-mb":R()}],"scroll-ml":[{"scroll-ml":R()}],"scroll-p":[{"scroll-p":R()}],"scroll-px":[{"scroll-px":R()}],"scroll-py":[{"scroll-py":R()}],"scroll-ps":[{"scroll-ps":R()}],"scroll-pe":[{"scroll-pe":R()}],"scroll-pbs":[{"scroll-pbs":R()}],"scroll-pbe":[{"scroll-pbe":R()}],"scroll-pt":[{"scroll-pt":R()}],"scroll-pr":[{"scroll-pr":R()}],"scroll-pb":[{"scroll-pb":R()}],"scroll-pl":[{"scroll-pl":R()}],"snap-align":[{snap:["start","end","center","align-none"]}],"snap-stop":[{snap:["normal","always"]}],"snap-type":[{snap:["none","x","y","both"]}],"snap-strictness":[{snap:["mandatory","proximity"]}],touch:[{touch:["auto","none","manipulation"]}],"touch-x":[{"touch-pan":["x","left","right"]}],"touch-y":[{"touch-pan":["y","up","down"]}],"touch-pz":["touch-pinch-zoom"],select:[{select:["none","text","all","auto"]}],"will-change":[{"will-change":["auto","scroll","contents","transform",x,P]}],fill:[{fill:["none",...S()]}],"stroke-w":[{stroke:[a,yY,Mq,EW]}],stroke:[{stroke:["none",...S()]}],"forced-color-adjust":[{"forced-color-adjust":["auto","none"]}]},conflictingClassGroups:{"container-named":["container-type"],overflow:["overflow-x","overflow-y"],overscroll:["overscroll-x","overscroll-y"],inset:["inset-x","inset-y","inset-bs","inset-be","start","end","top","right","bottom","left"],"inset-x":["right","left"],"inset-y":["top","bottom"],flex:["basis","grow","shrink"],gap:["gap-x","gap-y"],p:["px","py","ps","pe","pbs","pbe","pt","pr","pb","pl"],px:["pr","pl"],py:["pt","pb"],m:["mx","my","ms","me","mbs","mbe","mt","mr","mb","ml"],mx:["mr","ml"],my:["mt","mb"],size:["w","h"],"font-size":["leading"],"fvn-normal":["fvn-ordinal","fvn-slashed-zero","fvn-figure","fvn-spacing","fvn-fraction"],"fvn-ordinal":["fvn-normal"],"fvn-slashed-zero":["fvn-normal"],"fvn-figure":["fvn-normal"],"fvn-spacing":["fvn-normal"],"fvn-fraction":["fvn-normal"],"line-clamp":["display","overflow"],rounded:["rounded-s","rounded-e","rounded-t","rounded-r","rounded-b","rounded-l","rounded-ss","rounded-se","rounded-ee","rounded-es","rounded-tl","rounded-tr","rounded-br","rounded-bl"],"rounded-s":["rounded-ss","rounded-es"],"rounded-e":["rounded-se","rounded-ee"],"rounded-t":["rounded-tl","rounded-tr"],"rounded-r":["rounded-tr","rounded-br"],"rounded-b":["rounded-br","rounded-bl"],"rounded-l":["rounded-tl","rounded-bl"],"border-spacing":["border-spacing-x","border-spacing-y"],"border-w":["border-w-x","border-w-y","border-w-s","border-w-e","border-w-bs","border-w-be","border-w-t","border-w-r","border-w-b","border-w-l"],"border-w-x":["border-w-r","border-w-l"],"border-w-y":["border-w-t","border-w-b"],"border-color":["border-color-x","border-color-y","border-color-s","border-color-e","border-color-bs","border-color-be","border-color-t","border-color-r","border-color-b","border-color-l"],"border-color-x":["border-color-r","border-color-l"],"border-color-y":["border-color-t","border-color-b"],translate:["translate-x","translate-y","translate-none"],"translate-none":["translate","translate-x","translate-y","translate-z"],"scroll-m":["scroll-mx","scroll-my","scroll-ms","scroll-me","scroll-mbs","scroll-mbe","scroll-mt","scroll-mr","scroll-mb","scroll-ml"],"scroll-mx":["scroll-mr","scroll-ml"],"scroll-my":["scroll-mt","scroll-mb"],"scroll-p":["scroll-px","scroll-py","scroll-ps","scroll-pe","scroll-pbs","scroll-pbe","scroll-pt","scroll-pr","scroll-pb","scroll-pl"],"scroll-px":["scroll-pr","scroll-pl"],"scroll-py":["scroll-pt","scroll-pb"],touch:["touch-x","touch-y","touch-pz"],"touch-x":["touch"],"touch-y":["touch"],"touch-pz":["touch"]},conflictingClassGroupModifiers:{"font-size":["leading"]},postfixLookupClassGroups:["container-type"],orderSensitiveModifiers:["*","**","after","backdrop","before","details-content","file","first-letter","first-line","marker","placeholder","selection"]}};var uW=VN(CN);function z7(...A){return uW(L3(A))}var lW=y(uA(),1),PN=jW("inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium cursor-pointer transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50 disabled:cursor-not-allowed [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0",{variants:{variant:{default:"bg-primary text-primary-foreground shadow hover:bg-primary/90",destructive:"bg-destructive text-destructive-foreground shadow-sm hover:bg-destructive/90",outline:"border border-input bg-background shadow-sm hover:bg-accent hover:text-accent-foreground",secondary:"bg-secondary text-secondary-foreground shadow-sm hover:bg-secondary/80",ghost:"hover:bg-accent hover:text-accent-foreground",link:"text-primary underline-offset-4 hover:underline"},size:{default:"h-9 px-4 py-2",sm:"h-8 rounded-md px-3 text-xs",lg:"h-10 rounded-md px-8",icon:"h-9 w-9"}},defaultVariants:{variant:"default",size:"default"}}),oA=cW.forwardRef(({className:A,variant:M,size:Z,asChild:q=!1,...z},Y)=>{return lW.jsx(q?BW:"button",{className:z7(PN({variant:M,size:Z,className:A})),ref:Y,...z})});oA.displayName="Button";var xZ=y(l(),1);var C=y(l(),1),z1=y(Eq(),1);var xN=Object.defineProperty,yN=(A,M)=>xN(A,"name",{value:M,configurable:!0});function b3(A,[M,Z]){return Math.min(Z,Math.max(M,A))}yN(b3,"clamp");var hN=Object.defineProperty,Gz=(A,M)=>hN(A,"name",{value:M,configurable:!0}),iW=!!(typeof window<"u"&&window.document&&window.document.createElement);function LA(A,M,{checkForDefaultPrevented:Z=!0}={}){return Gz(function(z){if(A?.(z),Z===!1||!z||!z.defaultPrevented)return M?.(z)},"handleEvent")}Gz(LA,"composeEventHandlers");function vN(A){if(!iW)throw Error("Cannot access window outside of the DOM");return A?.ownerDocument?.defaultView??window}Gz(vN,"getOwnerWindow");function BU(A){if(!iW)throw Error("Cannot access document outside of the DOM");return A?.ownerDocument??document}Gz(BU,"getOwnerDocument");function rW(A,M=!1){let{activeElement:Z}=BU(A);if(!Z?.nodeName)return null;if(sW(Z)&&Z.contentDocument)return rW(Z.contentDocument.body,M);if(M){let q=Z.getAttribute("aria-activedescendant");if(q){let z=BU(Z).getElementById(q);if(z)return z}}return Z}Gz(rW,"getActiveElement");function sW(A){return A.tagName==="IFRAME"}Gz(sW,"isFrame");var Y7=y(l(),1);var _M=y(l(),1),GU=y(uA(),1),fN=Object.defineProperty,$M=(A,M)=>fN(A,"name",{value:M,configurable:!0});function gN(A,M){let Z=_M.createContext(M);Z.displayName=A+"Context";let q=$M((Y)=>{let{children:V,...Q}=Y,U=_M.useMemo(()=>Q,Object.values(Q));return GU.jsx(Z.Provider,{value:U,children:V})},"Provider");q.displayName=A+"Provider";function z(Y,V={}){let{optional:Q=!1}=V,U=_M.useContext(Z);if(U)return U;if(M!==void 0)return M;if(Q)return;throw Error(`\`${Y}\` must be used within \`${A}\``)}return $M(z,"useContext"),[q,z]}$M(gN,"createContext");function o7(A,M=[]){let Z=[];function q(Y,V){let Q=_M.createContext(V);Q.displayName=Y+"Context";let U=Z.length;Z=[...Z,V];let B=$M((J)=>{let{scope:I,children:K,...N}=J,O=I?.[A]?.[U]||Q,j=_M.useMemo(()=>N,Object.values(N));return GU.jsx(O.Provider,{value:j,children:K})},"Provider");B.displayName=Y+"Provider";function W(J,I,K={}){let{optional:N=!1}=K,O=I?.[A]?.[U]||Q,j=_M.useContext(O);if(j)return j;if(V!==void 0)return V;if(N)return;throw Error(`\`${J}\` must be used within \`${Y}\``)}return $M(W,"useContext"),[B,W]}$M(q,"createContext");let z=$M(()=>{let Y=Z.map((V)=>{return _M.createContext(V)});return $M(function(Q){let U=Q?.[A]||Y;return _M.useMemo(()=>({[`__scope${A}`]:{...Q,[A]:U}}),[Q,U])},"useScope")},"createScope");return z.scopeName=A,[q,oW(z,...M)]}$M(o7,"createContextScope");function oW(...A){let M=A[0];if(A.length===1)return M;let Z=$M(()=>{let q=A.map((z)=>({useScope:z(),scopeName:z.scopeName}));return $M(function(Y){let V=q.reduce((Q,{useScope:U,scopeName:B})=>{let J=U(Y)[`__scope${B}`];return{...Q,...J}},{});return _M.useMemo(()=>({[`__scope${M.scopeName}`]:V}),[V])},"useComposedScopes")},"createScope");return Z.scopeName=M.scopeName,Z}$M(oW,"composeContextScopes");var S3=y(uA(),1),OM=y(l(),1);var qq=y(uA(),1),uN=Object.defineProperty,aA=(A,M)=>uN(A,"name",{value:M,configurable:!0});function JU(A){let M=A+"CollectionProvider",[Z,q]=o7(M),[z,Y]=Z(M,{collectionRef:{current:null},itemMap:new Map}),V=aA((O)=>{let{scope:j,children:T}=O,G=Y7.useRef(null),D=Y7.useRef(new Map).current;return S3.jsx(z,{scope:j,itemMap:D,collectionRef:G,children:T})},"CollectionProvider");V.displayName=M;let Q=A+"CollectionSlot",U=nM(Q),B=Y7.forwardRef((O,j)=>{let{scope:T,children:G}=O,D=Y(Q,T),X=IA(j,D.collectionRef);return S3.jsx(U,{ref:X,children:G})});B.displayName=Q;let W=A+"CollectionItemSlot",J="data-radix-collection-item",I=nM(W),K=Y7.forwardRef((O,j)=>{let{scope:T,children:G,...D}=O,X=Y7.useRef(null),H=IA(j,X),L=Y(W,T);return Y7.useEffect(()=>{return L.itemMap.set(X,{ref:X,...D}),()=>void L.itemMap.delete(X)}),S3.jsx(I,{...{[J]:""},ref:H,children:G})});K.displayName=W;function N(O){let j=Y(A+"CollectionConsumer",O);return Y7.useCallback(()=>{let G=j.collectionRef.current;if(!G)return[];let D=Array.from(G.querySelectorAll(`[${J}]`));return Array.from(j.itemMap.values()).sort((L,F)=>D.indexOf(L.ref.current)-D.indexOf(F.ref.current))},[j.collectionRef,j.itemMap])}return aA(N,"useCollection"),[{Provider:V,Slot:B,ItemSlot:K},N,q]}aA(JU,"createCollection");var aW=new WeakMap,IU=class A extends Map{static{aA(this,"OrderedDict")}#A;constructor(M){super(M);this.#A=[...super.keys()],aW.set(this,!0)}set(M,Z){if(aW.get(this))if(this.has(M))this.#A[this.#A.indexOf(M)]=M;else this.#A.push(M);return super.set(M,Z),this}insert(M,Z,q){let z=this.has(Z),Y=this.#A.length,V=TU(M),Q=V>=0?V:Y+V,U=Q<0||Q>=Y?-1:Q;if(U===this.size||z&&U===this.size-1||U===-1)return this.set(Z,q),this;let B=this.size+(z?0:1);if(V<0)Q++;let W=[...this.#A],J,I=!1;for(let K=Q;K<B;K++)if(Q===K){let N=W[K];if(W[K]===Z)N=W[K+1];if(z)this.delete(Z);J=this.get(N),this.set(Z,q)}else{if(!I&&W[K-1]===Z)I=!0;let N=W[I?K:K-1],O=J;J=this.get(N),this.delete(N),this.set(N,O)}return this}with(M,Z,q){let z=new A(this);return z.insert(M,Z,q),z}before(M){let Z=this.#A.indexOf(M)-1;if(Z<0)return;return this.entryAt(Z)}setBefore(M,Z,q){let z=this.#A.indexOf(M);if(z===-1)return this;return this.insert(z,Z,q)}after(M){let Z=this.#A.indexOf(M);if(Z=Z===-1||Z===this.size-1?-1:Z+1,Z===-1)return;return this.entryAt(Z)}setAfter(M,Z,q){let z=this.#A.indexOf(M);if(z===-1)return this;return this.insert(z+1,Z,q)}first(){return this.entryAt(0)}last(){return this.entryAt(-1)}clear(){return this.#A=[],super.clear()}delete(M){let Z=super.delete(M);if(Z)this.#A.splice(this.#A.indexOf(M),1);return Z}deleteAt(M){let Z=this.keyAt(M);if(Z!==void 0)return this.delete(Z);return!1}at(M){let Z=P3(this.#A,M);if(Z!==void 0)return this.get(Z)}entryAt(M){let Z=P3(this.#A,M);if(Z!==void 0)return[Z,this.get(Z)]}indexOf(M){return this.#A.indexOf(M)}keyAt(M){return P3(this.#A,M)}from(M,Z){let q=this.indexOf(M);if(q===-1)return;let z=q+Z;if(z<0)z=0;if(z>=this.size)z=this.size-1;return this.at(z)}keyFrom(M,Z){let q=this.indexOf(M);if(q===-1)return;let z=q+Z;if(z<0)z=0;if(z>=this.size)z=this.size-1;return this.keyAt(z)}find(M,Z){let q=0;for(let z of this){if(Reflect.apply(M,Z,[z,q,this]))return z;q++}return}findIndex(M,Z){let q=0;for(let z of this){if(Reflect.apply(M,Z,[z,q,this]))return q;q++}return-1}filter(M,Z){let q=[],z=0;for(let Y of this){if(Reflect.apply(M,Z,[Y,z,this]))q.push(Y);z++}return new A(q)}map(M,Z){let q=[],z=0;for(let Y of this)q.push([Y[0],Reflect.apply(M,Z,[Y,z,this])]),z++;return new A(q)}reduce(...M){let[Z,q]=M,z=0,Y=q??this.at(0);for(let V of this){if(z===0&&M.length===1)Y=V;else Y=Reflect.apply(Z,this,[Y,V,z,this]);z++}return Y}reduceRight(...M){let[Z,q]=M,z=q??this.at(-1);for(let Y=this.size-1;Y>=0;Y--){let V=this.at(Y);if(Y===this.size-1&&M.length===1)z=V;else z=Reflect.apply(Z,this,[z,V,Y,this])}return z}toSorted(M){let Z=[...this.entries()].sort(M);return new A(Z)}toReversed(){let M=new A;for(let Z=this.size-1;Z>=0;Z--){let q=this.keyAt(Z),z=this.get(q);M.set(q,z)}return M}toSpliced(...M){let Z=[...this.entries()];return Z.splice(...M),new A(Z)}slice(M,Z){let q=new A,z=this.size-1;if(M===void 0)return q;if(M<0)M=M+this.size;if(Z!==void 0&&Z>0)z=Z-1;for(let Y=M;Y<=z;Y++){let V=this.keyAt(Y),Q=this.get(V);q.set(V,Q)}return q}every(M,Z){let q=0;for(let z of this){if(!Reflect.apply(M,Z,[z,q,this]))return!1;q++}return!0}some(M,Z){let q=0;for(let z of this){if(Reflect.apply(M,Z,[z,q,this]))return!0;q++}return!1}};function P3(A,M){if("at"in Array.prototype)return Array.prototype.at.call(A,M);let Z=nW(A,M);return Z===-1?void 0:A[Z]}aA(P3,"at");function nW(A,M){let Z=A.length,q=TU(M),z=q>=0?q:Z+q;return z<0||z>=Z?-1:z}aA(nW,"toSafeIndex");function TU(A){return A!==A||A===0?0:Math.trunc(A)}aA(TU,"toSafeInteger");function mN(A){let M=A+"CollectionProvider",[Z,q]=o7(M),[z,Y]=Z(M,{collectionElement:null,collectionRef:{current:null},collectionRefObject:{current:null},itemMap:new IU,setItemMap:aA(()=>{return},"setItemMap")}),V=aA(({state:D,...X})=>{return D?qq.jsx(U,{...X,state:D}):qq.jsx(Q,{...X})},"CollectionProvider");V.displayName=M;let Q=aA((D)=>{let X=j();return qq.jsx(U,{...D,state:X})},"CollectionInit");Q.displayName=M+"Init";let U=aA((D)=>{let{scope:X,children:H,state:L}=D,F=OM.useRef(null),[R,k]=OM.useState(null),b=IA(F,k),[u,h]=L;return OM.useEffect(()=>{if(!R)return;let p=tW(()=>{});return p.observe(R,{childList:!0,subtree:!0}),()=>{p.disconnect()}},[R]),qq.jsx(z,{scope:X,itemMap:u,setItemMap:h,collectionRef:b,collectionRefObject:F,collectionElement:R,children:H})},"CollectionProviderImpl");U.displayName=M+"Impl";let B=A+"CollectionSlot",W=nM(B),J=OM.forwardRef((D,X)=>{let{scope:H,children:L}=D,F=Y(B,H),R=IA(X,F.collectionRef);return qq.jsx(W,{ref:R,children:L})});J.displayName=B;let I=A+"CollectionItemSlot",K="data-radix-collection-item",N=nM(I),O=OM.forwardRef((D,X)=>{let{scope:H,children:L,...F}=D,R=OM.useRef(null),[k,b]=OM.useState(null),u=IA(X,R,b),h=Y(I,H),{setItemMap:p}=h,o=OM.useRef(F);if(!$W(o.current,F))o.current=F;let MA=o.current;return OM.useEffect(()=>{let g=MA;return p((i)=>{if(!k)return i;if(!i.has(k))return i.set(k,{...g,element:k}),i.toSorted(WU);return i.set(k,{...g,element:k}).toSorted(WU)}),()=>{p((i)=>{if(!k||!i.has(k))return i;return i.delete(k),new IU(i)})}},[k,MA,p]),qq.jsx(N,{...{[K]:""},ref:u,children:L})});O.displayName=I;function j(){return OM.useState(new IU)}aA(j,"useInitCollection");function T(D){let{itemMap:X}=Y(A+"CollectionConsumer",D);return X}return aA(T,"useCollection"),[{Provider:V,Slot:J,ItemSlot:O},{createCollectionScope:q,useCollection:T,useInitCollection:j}]}aA(mN,"createCollection");function $W(A,M){if(A===M)return!0;if(typeof A!=="object"||typeof M!=="object")return!1;if(A==null||M==null)return!1;let Z=Object.keys(A),q=Object.keys(M);if(Z.length!==q.length)return!1;for(let z of Z){if(!Object.prototype.hasOwnProperty.call(M,z))return!1;if(A[z]!==M[z])return!1}return!0}aA($W,"shallowEqual");function _W(A,M){return!!(M.compareDocumentPosition(A)&Node.DOCUMENT_POSITION_PRECEDING)}aA(_W,"isElementPreceding");function WU(A,M){return!A[1].element||!M[1].element?0:_W(A[1].element,M[1].element)?-1:1}aA(WU,"sortByDocumentPosition");function tW(A){return new MutationObserver((Z)=>{for(let q of Z)if(q.type==="childList"){A();return}})}aA(tW,"getChildListObserver");var x3=y(l(),1),cN=y(uA(),1),dN=Object.defineProperty,pN=(A,M)=>dN(A,"name",{value:M,configurable:!0}),lN=x3.createContext(void 0);function KU(A){let M=x3.useContext(lN);return A||M||"ltr"}pN(KU,"useDirection");var WA=y(l(),1);var eW=y(l(),1),A6=y(Eq(),1);var M6=y(uA(),1),iN=Object.defineProperty,rN=(A,M)=>iN(A,"name",{value:M,configurable:!0}),sN=["a","button","div","form","h2","h3","img","input","label","li","nav","ol","p","select","span","svg","ul"],wA=sN.reduce((A,M)=>{let Z=nM(`Primitive.${M}`),q=eW.forwardRef((z,Y)=>{let{asChild:V,...Q}=z,U=V?Z:M;if(typeof window<"u")window[Symbol.for("radix-ui")]=!0;return M6.jsx(U,{...Q,ref:Y})});return q.displayName=`Primitive.${M}`,{...A,[M]:q}},{});function DU(A,M){if(A)A6.flushSync(()=>A.dispatchEvent(M))}rN(DU,"dispatchDiscreteCustomEvent");var Iz=y(l(),1),oN=Object.defineProperty,aN=(A,M)=>oN(A,"name",{value:M,configurable:!0});function EM(A){let M=Iz.useRef(A);return Iz.useEffect(()=>{M.current=A}),Iz.useMemo(()=>(...Z)=>M.current?.(...Z),[])}aN(EM,"useCallbackRef");var q6=y(uA(),1),nN=Object.defineProperty,nA=(A,M)=>nN(A,"name",{value:M,configurable:!0}),NU="dismissableLayer.update",$N="dismissableLayer.pointerDownOutside",_N="dismissableLayer.focusOutside",Z6,z6=WA.createContext({layers:new Set,layersWithOutsidePointerEventsDisabled:new Set,branches:new Set,dismissableSurfaces:new Set}),Y6=WA.forwardRef(nA(function(M,Z){let{disableOutsidePointerEvents:q=!1,deferPointerDownOutside:z=!1,onEscapeKeyDown:Y,onPointerDownOutside:V,onFocusOutside:Q,onInteractOutside:U,onDismiss:B,...W}=M,J=WA.useContext(z6),[I,K]=WA.useState(null),N=I?.ownerDocument??globalThis?.document,[,O]=WA.useState({}),j=IA(Z,K),T=Array.from(J.layers),[G]=[...J.layersWithOutsidePointerEventsDisabled].slice(-1),D=G?T.indexOf(G):-1,X=I?T.indexOf(I):-1,H=J.layersWithOutsidePointerEventsDisabled.size>0,L=X>=D,F=WA.useRef(!1),R=V6((h)=>{if(V?.(h),U?.(h),!h.defaultPrevented)B?.()},{ownerDocument:N,deferPointerDownOutside:z,isDeferredPointerDownOutsideRef:F,dismissableSurfaces:J.dismissableSurfaces,shouldHandlePointerDownOutside:WA.useCallback((h)=>{if(!(h instanceof Node))return!1;let p=[...J.branches].some((o)=>o.contains(h));return L&&!p},[J.branches,L])}),k=Q6((h)=>{if(z&&F.current)return;let p=h.target;if([...J.branches].some((MA)=>MA.contains(p)))return;if(Q?.(h),U?.(h),!h.defaultPrevented)B?.()},N),b=I?X===T.length-1:!1,u=EM((h)=>{if(h.key!=="Escape")return;if(Y?.(h),!h.defaultPrevented&&B)h.preventDefault(),B()});return WA.useEffect(()=>{if(!b)return;return N.addEventListener("keydown",u,{capture:!0}),()=>N.removeEventListener("keydown",u,{capture:!0})},[N,b,u]),WA.useEffect(()=>{if(!I)return;if(q){if(J.layersWithOutsidePointerEventsDisabled.size===0)Z6=N.body.style.pointerEvents,N.body.style.pointerEvents="none";J.layersWithOutsidePointerEventsDisabled.add(I)}return J.layers.add(I),jU(),()=>{if(q){if(J.layersWithOutsidePointerEventsDisabled.delete(I),J.layersWithOutsidePointerEventsDisabled.size===0)N.body.style.pointerEvents=Z6}}},[I,N,q,J]),WA.useEffect(()=>{return()=>{if(!I)return;J.layers.delete(I),J.layersWithOutsidePointerEventsDisabled.delete(I),jU()}},[I,J]),WA.useEffect(()=>{let h=nA(()=>O({}),"handleUpdate");return document.addEventListener(NU,h),()=>document.removeEventListener(NU,h)},[]),q6.jsx(wA.div,{...W,ref:j,style:{pointerEvents:H?L?"auto":"none":void 0,...M.style},onFocusCapture:LA(M.onFocusCapture,k.onFocusCapture),onBlurCapture:LA(M.onBlurCapture,k.onBlurCapture),onPointerDownCapture:LA(M.onPointerDownCapture,R.onPointerDownCapture)})},"DismissableLayer"));function tN(){let A=WA.useContext(z6),[M,Z]=WA.useState(null);return WA.useEffect(()=>{if(!M)return;return A.dismissableSurfaces.add(M),()=>{A.dismissableSurfaces.delete(M)}},[M,A.dismissableSurfaces]),Z}nA(tN,"useDismissableLayerSurface");var eN=nA(()=>!0,"IS_TRUE");function V6(A,M){let{ownerDocument:Z=globalThis?.document,deferPointerDownOutside:q=!1,isDeferredPointerDownOutsideRef:z,dismissableSurfaces:Y,shouldHandlePointerDownOutside:V=eN}=M,Q=EM(A),U=WA.useRef(!1),B=WA.useRef(!1),W=WA.useRef(new Map),J=WA.useRef(()=>{});return WA.useEffect(()=>{function I(){B.current=!1,z.current=!1,W.current.clear()}nA(I,"resetOutsideInteraction");function K(){return Array.from(W.current.values()).some(Boolean)}nA(K,"isOutsideInteractionIntercepted");function N(D){if(!B.current)return;let X=D.target;if(!(X instanceof Node&&[...Y].some((L)=>L.contains(X))))W.current.set(D.type,!0);if(D.type==="click")window.setTimeout(()=>{if(B.current)J.current()},0)}nA(N,"handleInteractionCapture");function O(D){if(B.current)W.current.set(D.type,!1)}nA(O,"handleInteractionBubble");let j=nA((D)=>{if(D.target&&!U.current){let H=function(){Z.removeEventListener("click",J.current);let F=K();if(I(),!F)XU($N,Q,L,{discrete:!0})};var X=H;if(nA(H,"handleAndDispatchPointerDownOutsideEvent"),!V(D.target)){Z.removeEventListener("click",J.current),I(),U.current=!1;return}let L={originalEvent:D};if(B.current=!0,z.current=q&&D.button===0,W.current.clear(),!q||D.button!==0)H();else Z.removeEventListener("click",J.current),J.current=H,Z.addEventListener("click",J.current,{once:!0})}else Z.removeEventListener("click",J.current),I();U.current=!1},"handlePointerDown"),T=["pointerup","mousedown","mouseup","touchstart","touchend","click"];for(let D of T)Z.addEventListener(D,N,!0),Z.addEventListener(D,O);let G=window.setTimeout(()=>{Z.addEventListener("pointerdown",j)},0);return()=>{window.clearTimeout(G),Z.removeEventListener("pointerdown",j),Z.removeEventListener("click",J.current);for(let D of T)Z.removeEventListener(D,N,!0),Z.removeEventListener(D,O)}},[Z,Q,q,z,Y,V]),{onPointerDownCapture:nA(()=>U.current=!0,"onPointerDownCapture")}}nA(V6,"usePointerDownOutside");function Q6(A,M=globalThis?.document){let Z=EM(A),q=WA.useRef(!1);return WA.useEffect(()=>{let z=nA((Y)=>{if(Y.target&&!q.current)XU(_N,Z,{originalEvent:Y},{discrete:!1})},"handleFocus");return M.addEventListener("focusin",z),()=>M.removeEventListener("focusin",z)},[M,Z]),{onFocusCapture:nA(()=>q.current=!0,"onFocusCapture"),onBlurCapture:nA(()=>q.current=!1,"onBlurCapture")}}nA(Q6,"useFocusOutside");function jU(){let A=new CustomEvent(NU);document.dispatchEvent(A)}nA(jU,"dispatchUpdate");function XU(A,M,Z,{discrete:q}){let z=Z.originalEvent.target,Y=new CustomEvent(A,{bubbles:!1,cancelable:!0,detail:Z});if(M)z.addEventListener(A,M,{once:!0});if(q)DU(z,Y);else z.dispatchEvent(Y)}nA(XU,"handleAndDispatchCustomEvent");var U6=y(l(),1),Aj=Object.defineProperty,EU=(A,M)=>Aj(A,"name",{value:M,configurable:!0}),y3=0,Wz=null;function Mj(A){return h3(),A.children}EU(Mj,"FocusGuards");function h3(){U6.useEffect(()=>{if(!Wz)Wz={start:OU(),end:OU()};let{start:A,end:M}=Wz;if(document.body.firstElementChild!==A)document.body.insertAdjacentElement("afterbegin",A);if(document.body.lastElementChild!==M)document.body.insertAdjacentElement("beforeend",M);return y3++,()=>{if(y3===1)Wz?.start.remove(),Wz?.end.remove(),Wz=null;y3=Math.max(0,y3-1)}},[])}EU(h3,"useFocusGuards");function OU(){let A=document.createElement("span");return A.setAttribute("data-radix-focus-guard",""),A.tabIndex=0,A.style.outline="none",A.style.opacity="0",A.style.position="fixed",A.style.pointerEvents="none",A}EU(OU,"createFocusGuard");var tM=y(l(),1);var I6=y(uA(),1),Zj=Object.defineProperty,GM=(A,M)=>Zj(A,"name",{value:M,configurable:!0}),RU="focusScope.autoFocusOnMount",HU="focusScope.autoFocusOnUnmount",B6={bubbles:!1,cancelable:!0},W6=tM.forwardRef(GM(function(M,Z){let{loop:q=!1,trapped:z=!1,onMountAutoFocus:Y,onUnmountAutoFocus:V,...Q}=M,[U,B]=tM.useState(null),W=EM(Y),J=EM(V),I=tM.useRef(null),K=IA(Z,B),N=tM.useRef({paused:!1,pause(){this.paused=!0},resume(){this.paused=!1}}).current;tM.useEffect(()=>{if(z){let D=function(F){if(N.paused||!U)return;let R=F.target;if(U.contains(R))I.current=R;else a7(I.current,{select:!0})},X=function(F){if(N.paused||!U)return;let R=F.relatedTarget;if(R===null)return;if(!U.contains(R))a7(I.current,{select:!0})},H=function(F){if(document.activeElement!==document.body)return;for(let k of F)if(k.removedNodes.length>0)a7(U)};var j=D,T=X,G=H;GM(D,"handleFocusIn"),GM(X,"handleFocusOut"),GM(H,"handleMutations"),document.addEventListener("focusin",D),document.addEventListener("focusout",X);let L=new MutationObserver(H);if(U)L.observe(U,{childList:!0,subtree:!0});return()=>{document.removeEventListener("focusin",D),document.removeEventListener("focusout",X),L.disconnect()}}},[z,U,N.paused]),tM.useEffect(()=>{if(U){G6.add(N);let j=document.activeElement;if(!U.contains(j)){let G=new CustomEvent(RU,B6);if(U.addEventListener(RU,W),U.dispatchEvent(G),!G.defaultPrevented){if(J6(j6(wU(U)),{select:!0}),document.activeElement===j)a7(U)}}return()=>{U.removeEventListener(RU,W),setTimeout(()=>{let G=new CustomEvent(HU,B6);if(U.addEventListener(HU,J),U.dispatchEvent(G),!G.defaultPrevented)a7(j??document.body,{select:!0});U.removeEventListener(HU,J),G6.remove(N)},0)}}},[U,W,J,N]);let O=tM.useCallback((j)=>{if(!q&&!z)return;if(N.paused)return;let T=j.key==="Tab"&&!j.altKey&&!j.ctrlKey&&!j.metaKey,G=document.activeElement;if(T&&G){let D=j.currentTarget,[X,H]=T6(D);if(!(X&&H)){if(G===D)j.preventDefault()}else if(!j.shiftKey&&G===H){if(j.preventDefault(),q)a7(X,{select:!0})}else if(j.shiftKey&&G===X){if(j.preventDefault(),q)a7(H,{select:!0})}}},[q,z,N.paused]);return I6.jsx(wA.div,{tabIndex:-1,...Q,ref:K,onKeyDown:O})},"FocusScope"));function J6(A,{select:M=!1}={}){let Z=document.activeElement;for(let q of A)if(a7(q,{select:M}),document.activeElement!==Z)return}GM(J6,"focusFirst");function T6(A){let M=wU(A),Z=FU(M,A),q=FU(M.reverse(),A);return[Z,q]}GM(T6,"getTabbableEdges");function wU(A){let M=[],Z=document.createTreeWalker(A,NodeFilter.SHOW_ELEMENT,{acceptNode:GM((q)=>{let z=q.tagName==="INPUT"&&q.type==="hidden";if(q.disabled||q.hidden||z)return NodeFilter.FILTER_SKIP;return q.tabIndex>=0?NodeFilter.FILTER_ACCEPT:NodeFilter.FILTER_SKIP},"acceptNode")});while(Z.nextNode())M.push(Z.currentNode);return M}GM(wU,"getTabbableCandidates");function FU(A,M){let Z=typeof M.checkVisibility==="function"&&M.checkVisibility({checkVisibilityCSS:!0});for(let q of A)if(!(Z?!q.checkVisibility({checkVisibilityCSS:!0}):K6(q,{upTo:M})))return q}GM(FU,"findVisible");function K6(A,{upTo:M}){if(getComputedStyle(A).visibility==="hidden")return!0;while(A){if(M!==void 0&&A===M)return!1;if(getComputedStyle(A).display==="none")return!0;A=A.parentElement}return!1}GM(K6,"isHidden");function D6(A){return A instanceof HTMLInputElement&&"select"in A}GM(D6,"isSelectableInput");function a7(A,{select:M=!1}={}){if(A&&A.focus){let Z=document.activeElement;if(A.focus({preventScroll:!0}),A!==Z&&D6(A)&&M)A.select()}}GM(a7,"focus");var G6=N6();function N6(){let A=[];return{add(M){let Z=A[0];if(M!==Z)Z?.pause();A=LU(A,M),A.unshift(M)},remove(M){A=LU(A,M),A[0]?.resume()}}}GM(N6,"createFocusScopesStack");function LU(A,M){let Z=[...A],q=Z.indexOf(M);if(q!==-1)Z.splice(q,1);return Z}GM(LU,"arrayRemove");function j6(A){return A.filter((M)=>M.tagName!=="A")}GM(j6,"removeLinks");var kU=y(l(),1);var X6=y(l(),1),KA=globalThis?.document?X6.useLayoutEffect:()=>{};var qj=Object.defineProperty,zj=(A,M)=>qj(A,"name",{value:M,configurable:!0}),Yj=kU[" useId ".trim().toString()]||(()=>{return}),Vj=0;function v3(A){let[M,Z]=kU.useState(Yj());return KA(()=>{if(!A)Z((q)=>q??String(Vj++))},[A]),A||(M?`radix-${M}`:"")}zj(v3,"useId");var YM=y(l(),1);var R6=["top","right","bottom","left"];var{min:R7,max:V7,round:vY,floor:fY}=Math,H7=(A)=>({x:A,y:A}),Qj={left:"right",right:"left",bottom:"top",top:"bottom"};function CU(A,M,Z){return V7(A,R7(M,Z))}function F7(A,M){return typeof A==="function"?A(M):A}function n7(A){return A.split("-")[0]}function zq(A){return A.split("-")[1]}function g3(A){return A==="x"?"y":"x"}function u3(A){return A==="y"?"height":"width"}function Q7(A){let M=A[0];return M==="t"||M==="b"?"y":"x"}function m3(A){return g3(Q7(A))}function H6(A,M,Z){if(Z===void 0)Z=!1;let q=zq(A),z=m3(A),Y=u3(z),V=z==="x"?q===(Z?"end":"start")?"right":"left":q==="start"?"bottom":"top";if(M.reference[Y]>M.floating[Y])V=hY(V);return[V,hY(V)]}function F6(A){let M=hY(A);return[f3(A),M,f3(M)]}function f3(A){return A.includes("start")?A.replace("start","end"):A.replace("end","start")}var O6=["left","right"],E6=["right","left"],Uj=["top","bottom"],Bj=["bottom","top"];function Gj(A,M,Z){switch(A){case"top":case"bottom":if(Z)return M?E6:O6;return M?O6:E6;case"left":case"right":return M?Uj:Bj;default:return[]}}function L6(A,M,Z,q){let z=zq(A),Y=Gj(n7(A),Z==="start",q);if(z){if(Y=Y.map((V)=>V+"-"+z),M)Y=Y.concat(Y.map(f3))}return Y}function hY(A){let M=n7(A);return Qj[M]+A.slice(M.length)}function Ij(A){var M,Z,q,z;return{top:(M=A.top)!=null?M:0,right:(Z=A.right)!=null?Z:0,bottom:(q=A.bottom)!=null?q:0,left:(z=A.left)!=null?z:0}}function bU(A){return typeof A!=="number"?Ij(A):{top:A,right:A,bottom:A,left:A}}function Yq(A){let{x:M,y:Z,width:q,height:z}=A;return{width:q,height:z,top:Z,left:M,right:M+q,bottom:Z+z,x:M,y:Z}}function w6(A,M,Z){let{reference:q,floating:z}=A,Y=Q7(M),V=m3(M),Q=u3(V),U=n7(M),B=Y==="y",W=q.x+q.width/2-z.width/2,J=q.y+q.height/2-z.height/2,I=q[Q]/2-z[Q]/2,K;switch(U){case"top":K={x:W,y:q.y-z.height};break;case"bottom":K={x:W,y:q.y+q.height};break;case"right":K={x:q.x+q.width,y:J};break;case"left":K={x:q.x-z.width,y:J};break;default:K={x:q.x,y:q.y}}let N=zq(M);if(N)K[V]+=I*(N==="end"?1:-1)*(Z&&B?-1:1);return K}async function b6(A,M){var Z;if(M===void 0)M={};let{x:q,y:z,platform:Y,rects:V,elements:Q,strategy:U}=A,{boundary:B="clippingAncestors",rootBoundary:W="viewport",elementContext:J="floating",altBoundary:I=!1,padding:K=0}=F7(M,A),N=bU(K),j=Q[I?J==="floating"?"reference":"floating":J],T=Yq(await Y.getClippingRect({element:((Z=await(Y.isElement==null?void 0:Y.isElement(j)))!=null?Z:!0)?j:j.contextElement||await(Y.getDocumentElement==null?void 0:Y.getDocumentElement(Q.floating)),boundary:B,rootBoundary:W,strategy:U})),G=J==="floating"?{x:q,y:z,width:V.floating.width,height:V.floating.height}:V.reference,D=await(Y.getOffsetParent==null?void 0:Y.getOffsetParent(Q.floating)),X=await(Y.isElement==null?void 0:Y.isElement(D))&&await(Y.getScale==null?void 0:Y.getScale(D))||{x:1,y:1},H=Yq(Y.convertOffsetParentRelativeRectToViewportRelativeRect?await Y.convertOffsetParentRelativeRectToViewportRelativeRect({elements:Q,rect:G,offsetParent:D,strategy:U}):G);return{top:(T.top-H.top+N.top)/X.y,bottom:(H.bottom-T.bottom+N.bottom)/X.y,left:(T.left-H.left+N.left)/X.x,right:(H.right-T.right+N.right)/X.x}}var Wj=50,S6=async(A,M,Z)=>{let{placement:q="bottom",strategy:z="absolute",middleware:Y=[],platform:V}=Z,Q=V.detectOverflow?V:{...V,detectOverflow:b6},U=await(V.isRTL==null?void 0:V.isRTL(M)),B=await V.getElementRects({reference:A,floating:M,strategy:z}),{x:W,y:J}=w6(B,q,U),I=q,K=0,N={};for(let O=0;O<Y.length;O++){let j=Y[O];if(!j)continue;let{name:T,fn:G}=j,{x:D,y:X,data:H,reset:L}=await G({x:W,y:J,initialPlacement:q,placement:I,strategy:z,middlewareData:N,rects:B,platform:Q,elements:{reference:A,floating:M}});if(W=D!=null?D:W,J=X!=null?X:J,N[T]={...N[T],...H},L&&K<Wj){if(K++,typeof L==="object"){if(L.placement)I=L.placement;if(L.rects)B=L.rects===!0?await V.getElementRects({reference:A,floating:M,strategy:z}):L.rects;({x:W,y:J}=w6(B,I,U))}O=-1}}return{x:W,y:J,placement:I,strategy:z,middlewareData:N}},P6=(A)=>({name:"arrow",options:A,async fn(M){let{x:Z,y:q,placement:z,rects:Y,platform:V,elements:Q,middlewareData:U}=M,{element:B,padding:W=0}=F7(A,M)||{};if(B==null)return{};let J=bU(W),I={x:Z,y:q},K=m3(z),N=u3(K),O=await V.getDimensions(B),j=K==="y",T=j?"top":"left",G=j?"bottom":"right",D=j?"clientHeight":"clientWidth",X=Y.reference[N]+Y.reference[K]-I[K]-Y.floating[N],H=I[K]-Y.reference[K],L=await(V.getOffsetParent==null?void 0:V.getOffsetParent(B)),F=L?L[D]:0;if(!F||!await(V.isElement==null?void 0:V.isElement(L)))F=Q.floating[D]||Y.floating[N];let R=X/2-H/2,k=F/2-O[N]/2-1,b=R7(J[T],k),u=R7(J[G],k),h=F-O[N]-u,p=F/2-O[N]/2+R,o=CU(b,p,h),MA=!U.arrow&&zq(z)!=null&&p!==o&&Y.reference[N]/2-(p<b?b:u)-O[N]/2<0,g=MA?p<b?p-b:p-h:0;return{[K]:I[K]+g,data:{[K]:o,centerOffset:p-o-g,...MA&&{alignmentOffset:g}},reset:MA}}});var x6=function(A){if(A===void 0)A={};return{name:"flip",options:A,async fn(M){var Z,q;let{placement:z,middlewareData:Y,rects:V,initialPlacement:Q,platform:U,elements:B}=M,{mainAxis:W=!0,crossAxis:J=!0,fallbackPlacements:I,fallbackStrategy:K="bestFit",fallbackAxisSideDirection:N="none",flipAlignment:O=!0,...j}=F7(A,M);if((Z=Y.arrow)!=null&&Z.alignmentOffset)return{};let T=n7(z),G=Q7(Q),D=n7(Q)===Q,X=await(U.isRTL==null?void 0:U.isRTL(B.floating)),H=I||(D||!O?[hY(Q)]:F6(Q)),L=N!=="none";if(!I&&L)H.push(...L6(Q,O,N,X));let F=[Q,...H],R=await U.detectOverflow(M,j),k=[],b=((q=Y.flip)==null?void 0:q.overflows)||[];if(W)k.push(R[T]);if(J){let o=H6(z,V,X);k.push(R[o[0]],R[o[1]])}if(b=[...b,{placement:z,overflows:k}],!k.every((o)=>o<=0)){var u,h;let o=(((u=Y.flip)==null?void 0:u.index)||0)+1,MA=F[o];if(MA){if(!(J==="alignment"?G!==Q7(MA):!1)||b.every((m)=>Q7(m.placement)===G?m.overflows[0]>0:!0))return{data:{index:o,overflows:b},reset:{placement:MA}}}let g=(h=b.filter((i)=>i.overflows[0]<=0).sort((i,m)=>i.overflows[1]-m.overflows[1])[0])==null?void 0:h.placement;if(!g)switch(K){case"bestFit":{var p;let i=(p=b.filter((m)=>{if(L){let ZA=Q7(m.placement);return ZA===G||ZA==="y"}return!0}).map((m)=>[m.placement,m.overflows.filter((ZA)=>ZA>0).reduce((ZA,S)=>ZA+S,0)]).sort((m,ZA)=>m[1]-ZA[1])[0])==null?void 0:p[0];if(i)g=i;break}case"initialPlacement":g=Q;break}if(z!==g)return{reset:{placement:g}}}return{}}}};function k6(A,M){return{top:A.top-M.height,right:A.right-M.width,bottom:A.bottom-M.height,left:A.left-M.width}}function C6(A){return R6.some((M)=>A[M]>=0)}var y6=function(A){if(A===void 0)A={};return{name:"hide",options:A,async fn(M){let{rects:Z,platform:q}=M,{strategy:z="referenceHidden",...Y}=F7(A,M);switch(z){case"referenceHidden":{let V=await q.detectOverflow(M,{...Y,elementContext:"reference"}),Q=k6(V,Z.reference);return{data:{referenceHiddenOffsets:Q,referenceHidden:C6(Q)}}}case"escaped":{let V=await q.detectOverflow(M,{...Y,altBoundary:!0}),Q=k6(V,Z.floating);return{data:{escapedOffsets:Q,escaped:C6(Q)}}}default:return{}}}}};var h6=new Set(["left","top"]);async function Jj(A,M){let{placement:Z,platform:q,elements:z}=A,Y=await(q.isRTL==null?void 0:q.isRTL(z.floating)),V=n7(Z),Q=zq(Z),U=Q7(Z)==="y",B=h6.has(V)?-1:1,W=Y&&U?-1:1,J=F7(M,A),{mainAxis:I,crossAxis:K,alignmentAxis:N}=typeof J==="number"?{mainAxis:J,crossAxis:0,alignmentAxis:null}:{mainAxis:J.mainAxis||0,crossAxis:J.crossAxis||0,alignmentAxis:J.alignmentAxis};if(Q&&typeof N==="number")K=Q==="end"?N*-1:N;return U?{x:K*W,y:I*B}:{x:I*B,y:K*W}}var v6=function(A){if(A===void 0)A=0;return{name:"offset",options:A,async fn(M){var Z,q;let{x:z,y:Y,placement:V,middlewareData:Q}=M,U=await Jj(M,A);if(V===((Z=Q.offset)==null?void 0:Z.placement)&&(q=Q.arrow)!=null&&q.alignmentOffset)return{};return{x:z+U.x,y:Y+U.y,data:{...U,placement:V}}}}},f6=function(A){if(A===void 0)A={};return{name:"shift",options:A,async fn(M){let{x:Z,y:q,placement:z,platform:Y}=M,{mainAxis:V=!0,crossAxis:Q=!1,limiter:U={fn:(G)=>{let{x:D,y:X}=G;return{x:D,y:X}}},...B}=F7(A,M),W={x:Z,y:q},J=await Y.detectOverflow(M,B),I=Q7(z),K=g3(I),N=W[K],O=W[I],j=(G,D)=>CU(D+J[G==="y"?"top":"left"],D,D-J[G==="y"?"bottom":"right"]);if(V)N=j(K,N);if(Q)O=j(I,O);let T=U.fn({...M,[K]:N,[I]:O});return{...T,data:{x:T.x-Z,y:T.y-q,enabled:{[K]:V,[I]:Q}}}}}},g6=function(A){if(A===void 0)A={};return{options:A,fn(M){var Z,q;let{x:z,y:Y,placement:V,rects:Q,middlewareData:U}=M,{offset:B=0,mainAxis:W=!0,crossAxis:J=!0}=F7(A,M),I={x:z,y:Y},K=Q7(V),N=g3(K),O=I[N],j=I[K],T=F7(B,M),G=typeof T==="number"?{mainAxis:T,crossAxis:0}:{mainAxis:(Z=T.mainAxis)!=null?Z:0,crossAxis:(q=T.crossAxis)!=null?q:0};if(W){let H=N==="y"?"height":"width",L=Q.reference[N]-Q.floating[H]+G.mainAxis,F=Q.reference[N]+Q.reference[H]-G.mainAxis;if(O<L)O=L;else if(O>F)O=F}if(J){var D,X;let H=N==="y"?"width":"height",L=h6.has(n7(V)),F=Q.reference[K]-Q.floating[H]+(L?((D=U.offset)==null?void 0:D[K])||0:0)+(L?0:G.crossAxis),R=Q.reference[K]+Q.reference[H]+(L?0:((X=U.offset)==null?void 0:X[K])||0)-(L?G.crossAxis:0);if(j<F)j=F;else if(j>R)j=R}return{[N]:O,[K]:j}}}},u6=function(A){if(A===void 0)A={};return{name:"size",options:A,async fn(M){let{placement:Z,rects:q,platform:z,elements:Y}=M,{apply:V=()=>{},...Q}=F7(A,M),U=await z.detectOverflow(M,Q),B=n7(Z),W=zq(Z),J=Q7(Z)==="y",{width:I,height:K}=q.floating,N,O;if(B==="top"||B==="bottom")N=B,O=W===(await(z.isRTL==null?void 0:z.isRTL(Y.floating))?"start":"end")?"left":"right";else O=B,N=W==="end"?"top":"bottom";let j=K-U.top-U.bottom,T=I-U.left-U.right,G=R7(K-U[N],j),D=R7(I-U[O],T),X=M.middlewareData.shift,H=!X,L=G,F=D;if(X!=null&&X.enabled.x)F=T;if(X!=null&&X.enabled.y)L=j;if(H&&!W)if(J)F=I-2*V7(U.left,U.right);else L=K-2*V7(U.top,U.bottom);await V({...M,availableWidth:F,availableHeight:L});let R=await z.getDimensions(Y.floating);if(I!==R.width||K!==R.height)return{reset:{rects:!0}};return{}}}};function d3(){return typeof window<"u"}function Uq(A){if(d6(A))return(A.nodeName||"").toLowerCase();return"#document"}function IM(A){var M;return(A==null||(M=A.ownerDocument)==null?void 0:M.defaultView)||window}function L7(A){var M;return(M=(d6(A)?A.ownerDocument:A.document)||window.document)==null?void 0:M.documentElement}function d6(A){if(!d3())return!1;return A instanceof Node||A instanceof IM(A).Node}function U7(A){if(!d3())return!1;return A instanceof Element||A instanceof IM(A).Element}function $7(A){if(!d3())return!1;return A instanceof HTMLElement||A instanceof IM(A).HTMLElement}function m6(A){if(!d3()||typeof ShadowRoot>"u")return!1;return A instanceof ShadowRoot||A instanceof IM(A).ShadowRoot}function gY(A){let{overflow:M,overflowX:Z,overflowY:q,display:z}=B7(A);return/auto|scroll|overlay|hidden|clip/.test(M+q+Z)&&z!=="inline"&&z!=="contents"}function p6(A){return/^(table|td|th)$/.test(Uq(A))}function uY(A){try{if(A.matches(":popover-open"))return!0}catch(M){}try{return A.matches(":modal")}catch(M){return!1}}var Tj=/transform|translate|scale|rotate|perspective|filter/,Kj=/paint|layout|strict|content/,Vq=(A)=>!!A&&A!=="none",SU;function p3(A){let M=U7(A)?B7(A):A;return Vq(M.transform)||Vq(M.translate)||Vq(M.scale)||Vq(M.rotate)||Vq(M.perspective)||!c3()&&(Vq(M.backdropFilter)||Vq(M.filter))||Tj.test(M.willChange||"")||Kj.test(M.contain||"")}function c6(A){let M=CZ(A);while($7(M)&&!Jz(M)){if(p3(M))return M;else if(uY(M))return null;M=CZ(M)}return null}function c3(){if(SU==null)SU=typeof CSS<"u"&&CSS.supports&&CSS.supports("-webkit-backdrop-filter","none");return SU}function Jz(A){return/^(html|body|#document)$/.test(Uq(A))}function B7(A){return IM(A).getComputedStyle(A)}function mY(A){if(U7(A))return{scrollLeft:A.scrollLeft,scrollTop:A.scrollTop};return{scrollLeft:A.scrollX,scrollTop:A.scrollY}}function CZ(A){if(Uq(A)==="html")return A;let M=A.assignedSlot||A.parentNode||m6(A)&&A.host||L7(A);return m6(M)?M.host:M}function l6(A){let M=CZ(A);if(Jz(M))return(A.ownerDocument||A).body;if($7(M)&&gY(M))return M;return l6(M)}function Qq(A,M,Z){var q;if(M===void 0)M=[];if(Z===void 0)Z=!0;let z=l6(A),Y=z===((q=A.ownerDocument)==null?void 0:q.body),V=IM(z);if(Y){let Q=l3(V);return M.concat(V,V.visualViewport||[],gY(z)?z:[],Q&&Z?Qq(Q):[])}else return M.concat(z,Qq(z,[],Z))}function l3(A){return A.parent&&Object.getPrototypeOf(A.parent)?A.frameElement:null}function s6(A){let M=B7(A),Z=parseFloat(M.width)||0,q=parseFloat(M.height)||0,z=$7(A),Y=z?A.offsetWidth:Z,V=z?A.offsetHeight:q,Q=vY(Z)!==Y||vY(q)!==V;if(Q)Z=Y,q=V;return{width:Z,height:q,$:Q}}function xU(A){return!U7(A)?A.contextElement:A}function Tz(A){let M=xU(A);if(!$7(M))return H7(1);let Z=M.getBoundingClientRect(),{width:q,height:z,$:Y}=s6(M),V=(Y?vY(Z.width):Z.width)/q,Q=(Y?vY(Z.height):Z.height)/z;if(!V||!Number.isFinite(V))V=1;if(!Q||!Number.isFinite(Q))Q=1;return{x:V,y:Q}}var Dj=H7(0);function o6(A){let M=IM(A);if(!c3()||!M.visualViewport)return Dj;return{x:M.visualViewport.offsetLeft,y:M.visualViewport.offsetTop}}function Nj(A,M,Z){if(M===void 0)M=!1;return!!Z&&M&&Z===IM(A)}function Bq(A,M,Z,q){if(M===void 0)M=!1;if(Z===void 0)Z=!1;let z=A.getBoundingClientRect(),Y=xU(A),V=H7(1);if(M)if(q){if(U7(q))V=Tz(q)}else V=Tz(A);let Q=Nj(Y,Z,q)?o6(Y):H7(0),U=(z.left+Q.x)/V.x,B=(z.top+Q.y)/V.y,W=z.width/V.x,J=z.height/V.y;if(Y&&q){let I=IM(Y),K=U7(q)?IM(q):q,N=I,O=l3(N);while(O&&K!==N){let j=Tz(O),T=O.getBoundingClientRect(),G=B7(O),D=T.left+(O.clientLeft+parseFloat(G.paddingLeft))*j.x,X=T.top+(O.clientTop+parseFloat(G.paddingTop))*j.y;U*=j.x,B*=j.y,W*=j.x,J*=j.y,U+=D,B+=X,N=IM(O),O=l3(N)}}return Yq({width:W,height:J,x:U,y:B})}function i3(A,M){let Z=mY(A).scrollLeft;if(!M)return Bq(L7(A)).left+Z;return M.left+Z}function a6(A,M){let Z=A.getBoundingClientRect(),q=Z.left+M.scrollLeft-i3(A,Z),z=Z.top+M.scrollTop;return{x:q,y:z}}function jj(A){let{elements:M,rect:Z,offsetParent:q,strategy:z}=A,Y=z==="fixed",V=L7(q),Q=M?uY(M.floating):!1;if(q===V||Q&&Y)return Z;let U={scrollLeft:0,scrollTop:0},B=H7(1),W=H7(0),J=$7(q);if(J||!Y){if(Uq(q)!=="body"||gY(V))U=mY(q);if(J){let K=Bq(q);B=Tz(q),W.x=K.x+q.clientLeft,W.y=K.y+q.clientTop}}let I=V&&!J&&!Y?a6(V,U):H7(0);return{width:Z.width*B.x,height:Z.height*B.y,x:Z.x*B.x-U.scrollLeft*B.x+W.x+I.x,y:Z.y*B.y-U.scrollTop*B.y+W.y+I.y}}function Xj(A){return A.getClientRects?Array.from(A.getClientRects()):[]}function Oj(A){let M=mY(A),Z=A.ownerDocument.body,q=V7(A.scrollWidth,A.clientWidth,Z.scrollWidth,Z.clientWidth),z=V7(A.scrollHeight,A.clientHeight,Z.scrollHeight,Z.clientHeight),Y=-M.scrollLeft+i3(A),V=-M.scrollTop;if(B7(Z).direction==="rtl")Y+=V7(A.clientWidth,Z.clientWidth)-q;return{width:q,height:z,x:Y,y:V}}var Ej=25;function Rj(A,M,Z){if(Z===void 0)Z="viewport";let q=Z==="layoutViewport",z=IM(A),Y=L7(A),V=z.visualViewport,Q=Y.clientWidth,U=Y.clientHeight,B=0,W=0;if(V){let I=!c3()||M==="fixed";if(q){if(!I)B=-V.offsetLeft,W=-V.offsetTop}else if(Q=V.width,U=V.height,I)B=V.offsetLeft,W=V.offsetTop}if(i3(Y)<=0){let I=Y.ownerDocument,K=I.body,N=getComputedStyle(K),O=I.compatMode==="CSS1Compat"?parseFloat(N.marginLeft)+parseFloat(N.marginRight)||0:0,j=Math.abs(Y.clientWidth-K.clientWidth-O),T=getComputedStyle(Y).scrollbarGutter==="stable both-edges"?j/2:j;if(T<=Ej)Q-=T}return{width:Q,height:U,x:B,y:W}}function Hj(A,M){let Z=Bq(A,!0,M==="fixed"),q=Z.top+A.clientTop,z=Z.left+A.clientLeft,Y=Tz(A),V=A.clientWidth*Y.x,Q=A.clientHeight*Y.y,U=z*Y.x,B=q*Y.y;return{width:V,height:Q,x:U,y:B}}function i6(A,M,Z){let q;if(M==="viewport"||M==="layoutViewport")q=Rj(A,Z,M);else if(M==="document")q=Oj(L7(A));else if(U7(M))q=Hj(M,Z);else{let z=o6(A);q={x:M.x-z.x,y:M.y-z.y,width:M.width,height:M.height}}return Yq(q)}function Fj(A,M){let Z=M.get(A);if(Z)return Z;let q=Qq(A,[],!1).filter((Q)=>U7(Q)&&Uq(Q)!=="body"),z=null,Y=B7(A).position==="fixed",V=Y?CZ(A):A;while(U7(V)&&!Jz(V)){let Q=B7(V),U=p3(V),B=z?z.position:Y?"fixed":"";if(!U&&(B==="fixed"||B==="absolute"&&Q.position==="static"))q=q.filter((J)=>J!==V);else z=Q;V=CZ(V)}return M.set(A,q),q}function Lj(A){let{element:M,boundary:Z,rootBoundary:q,strategy:z}=A,V=[...Z==="clippingAncestors"?uY(M)?[]:Fj(M,this._c):[].concat(Z),q],Q=i6(M,V[0],z),U=Q.top,B=Q.right,W=Q.bottom,J=Q.left;for(let I=1;I<V.length;I++){let K=i6(M,V[I],z);U=V7(K.top,U),B=R7(K.right,B),W=R7(K.bottom,W),J=V7(K.left,J)}return{width:B-J,height:W-U,x:J,y:U}}function wj(A){let{width:M,height:Z}=s6(A);return{width:M,height:Z}}function kj(A,M,Z){let q=$7(M),z=L7(M),Y=Z==="fixed",V=Bq(A,!0,Y,M),Q={scrollLeft:0,scrollTop:0},U=H7(0);if(q||!Y){if(Uq(M)!=="body"||gY(z))Q=mY(M);if(q){let I=Bq(M,!0,Y,M);U.x=I.x+M.clientLeft,U.y=I.y+M.clientTop}}if(!q&&z)U.x=i3(z);let B=z&&!q&&!Y?a6(z,Q):H7(0),W=V.left+Q.scrollLeft-U.x-B.x,J=V.top+Q.scrollTop-U.y-B.y;return{x:W,y:J,width:V.width,height:V.height}}function PU(A){return B7(A).position==="static"}function r6(A,M){if(!$7(A)||B7(A).position==="fixed")return null;if(M)return M(A);let Z=A.offsetParent;if(L7(A)===Z)Z=Z.ownerDocument.body;return Z}function n6(A,M){let Z=IM(A);if(uY(A))return Z;if(!$7(A)){let z=CZ(A);while(z&&!Jz(z)){if(U7(z)&&!PU(z))return z;z=CZ(z)}return Z}let q=r6(A,M);while(q&&p6(q)&&PU(q))q=r6(q,M);if(q&&Jz(q)&&PU(q)&&!p3(q))return Z;return q||c6(A)||Z}var Cj=async function(A){let M=this.getOffsetParent||n6,Z=this.getDimensions,q=await Z(A.floating);return{reference:kj(A.reference,await M(A.floating),A.strategy),floating:{x:0,y:0,width:q.width,height:q.height}}};function bj(A){return B7(A).direction==="rtl"}var $6={convertOffsetParentRelativeRectToViewportRelativeRect:jj,getDocumentElement:L7,getClippingRect:Lj,getOffsetParent:n6,getElementRects:Cj,getClientRects:Xj,getDimensions:wj,getScale:Tz,isElement:U7,isRTL:bj};function _6(A,M){return A.x===M.x&&A.y===M.y&&A.width===M.width&&A.height===M.height}function Sj(A,M,Z){let q=null,z,Y=L7(A);function V(){var W;clearTimeout(z),(W=q)==null||W.disconnect(),q=null}function Q(W,J){if(W===void 0)W=!1;if(J===void 0)J=1;V();let I=A.getBoundingClientRect(),{left:K,top:N,width:O,height:j}=I;if(!W)M();if(!O||!j)return;let T=fY(N),G=fY(Y.clientWidth-(K+O)),D=fY(Y.clientHeight-(N+j)),X=fY(K),L={rootMargin:-T+"px "+-G+"px "+-D+"px "+-X+"px",threshold:V7(0,R7(1,J))||1},F=!0;function R(k){let b=k[0].intersectionRatio;if(!_6(I,A.getBoundingClientRect()))return Q();if(b!==J){if(!F)return Q();if(!b)z=setTimeout(()=>{Q(!1,0.0000001)},1000);else Q(!1,b)}F=!1}try{q=new IntersectionObserver(R,{...L,root:Y.ownerDocument})}catch(k){q=new IntersectionObserver(R,L)}q.observe(A)}let U=IM(A),B=()=>Q(Z);return U.addEventListener("resize",B),Q(!0),()=>{U.removeEventListener("resize",B),V()}}function yU(A,M,Z,q){if(q===void 0)q={};let{ancestorScroll:z=!0,ancestorResize:Y=!0,elementResize:V=typeof ResizeObserver==="function",layoutShift:Q=typeof IntersectionObserver==="function",animationFrame:U=!1}=q,B=xU(A),W=z||Y?[...B?Qq(B):[],...M?Qq(M):[]]:[];W.forEach((T)=>{z&&T.addEventListener("scroll",Z),Y&&T.addEventListener("resize",Z)});let J=B&&Q?Sj(B,Z,Y):null,I=-1,K=null;if(V){if(K=new ResizeObserver((T)=>{let[G]=T;if(G&&G.target===B&&K&&M)K.unobserve(M),cancelAnimationFrame(I),I=requestAnimationFrame(()=>{var D;(D=K)==null||D.observe(M)});Z()}),B&&!U)K.observe(B);if(M)K.observe(M)}let N,O=U?Bq(A):null;if(U)j();function j(){let T=Bq(A);if(O&&!_6(O,T))Z();O=T,N=requestAnimationFrame(j)}return Z(),()=>{var T;if(W.forEach((G)=>{z&&G.removeEventListener("scroll",Z),Y&&G.removeEventListener("resize",Z)}),J==null||J(),(T=K)==null||T.disconnect(),K=null,U)cancelAnimationFrame(N)}}var t6=v6;var e6=f6,AJ=x6,MJ=u6,ZJ=y6,hU=P6;var qJ=g6,vU=(A,M,Z)=>{let q=new Map,z=Z!=null?Z:{},Y={...$6,...z.platform,_c:q};return S6(A,M,{...z,platform:Y})};var mA=y(l(),1),YJ=y(l(),1),VJ=y(Eq(),1),Pj=typeof document<"u",xj=function(){},r3=Pj?YJ.useLayoutEffect:xj;function s3(A,M){if(A===M)return!0;if(typeof A!==typeof M)return!1;if(typeof A==="function"&&A.toString()===M.toString())return!0;let Z,q,z;if(A&&M&&typeof A==="object"){if(Array.isArray(A)){if(Z=A.length,Z!==M.length)return!1;for(q=Z;q--!==0;)if(!s3(A[q],M[q]))return!1;return!0}if(z=Object.keys(A),Z=z.length,Z!==Object.keys(M).length)return!1;for(q=Z;q--!==0;)if(!{}.hasOwnProperty.call(M,z[q]))return!1;for(q=Z;q--!==0;){let Y=z[q];if(Y==="_owner"&&A.$$typeof)continue;if(!s3(A[Y],M[Y]))return!1}return!0}return A!==A&&M!==M}function QJ(A){if(typeof window>"u")return 1;return(A.ownerDocument.defaultView||window).devicePixelRatio||1}function zJ(A,M){let Z=QJ(A);return Math.round(M*Z)/Z}function fU(A){let M=mA.useRef(A);return r3(()=>{M.current=A}),M}function UJ(A){if(A===void 0)A={};let{placement:M="bottom",strategy:Z="absolute",middleware:q=[],platform:z,elements:{reference:Y,floating:V}={},transform:Q=!0,whileElementsMounted:U,open:B}=A,[W,J]=mA.useState({x:0,y:0,strategy:Z,placement:M,middlewareData:{},isPositioned:!1}),[I,K]=mA.useState(q);if(!s3(I,q))K(q);let[N,O]=mA.useState(null),[j,T]=mA.useState(null),G=mA.useCallback((m)=>{if(m!==L.current)L.current=m,O(m)},[]),D=mA.useCallback((m)=>{if(m!==F.current)F.current=m,T(m)},[]),X=Y||N,H=V||j,L=mA.useRef(null),F=mA.useRef(null),R=mA.useRef(W),k=U!=null,b=fU(U),u=fU(z),h=fU(B),p=mA.useCallback(()=>{if(!L.current||!F.current)return;let m={placement:M,strategy:Z,middleware:I};if(u.current)m.platform=u.current;vU(L.current,F.current,m).then((ZA)=>{let S={...ZA,isPositioned:h.current!==!1};if(o.current&&!s3(R.current,S))R.current=S,VJ.flushSync(()=>{J(S)})})},[I,M,Z,u,h]);r3(()=>{if(B===!1&&R.current.isPositioned)R.current.isPositioned=!1,J((m)=>({...m,isPositioned:!1}))},[B]);let o=mA.useRef(!1);r3(()=>{return o.current=!0,()=>{o.current=!1}},[]),r3(()=>{if(X)L.current=X;if(H)F.current=H;if(X&&H){if(b.current)return b.current(X,H,p);p()}},[X,H,p,b,k]);let MA=mA.useMemo(()=>({reference:L,floating:F,setReference:G,setFloating:D}),[G,D]),g=mA.useMemo(()=>({reference:X,floating:H}),[X,H]),i=mA.useMemo(()=>{let m={position:Z,left:0,top:0};if(!g.floating)return m;let ZA=zJ(g.floating,W.x),S=zJ(g.floating,W.y);if(Q)return{...m,transform:"translate("+ZA+"px, "+S+"px)",...QJ(g.floating)>=1.5&&{willChange:"transform"}};return{position:Z,left:ZA,top:S}},[Z,Q,g.floating,W.x,W.y]);return mA.useMemo(()=>({...W,update:p,refs:MA,elements:g,floatingStyles:i}),[W,p,MA,g,i])}var yj=(A)=>{function M(Z){return{}.hasOwnProperty.call(Z,"current")}return{name:"arrow",options:A,fn(Z){let{element:q,padding:z}=typeof A==="function"?A(Z):A;if(q&&M(q)){if(q.current!=null)return hU({element:q.current,padding:z}).fn(Z);return{}}if(q)return hU({element:q,padding:z}).fn(Z);return{}}}},BJ=(A,M)=>{let Z=t6(A);return{name:Z.name,fn:Z.fn,options:[A,M]}},GJ=(A,M)=>{let Z=e6(A);return{name:Z.name,fn:Z.fn,options:[A,M]}},IJ=(A,M)=>{return{fn:qJ(A).fn,options:[A,M]}},WJ=(A,M)=>{let Z=AJ(A);return{name:Z.name,fn:Z.fn,options:[A,M]}},JJ=(A,M)=>{let Z=MJ(A);return{name:Z.name,fn:Z.fn,options:[A,M]}};var TJ=(A,M)=>{let Z=ZJ(A);return{name:Z.name,fn:Z.fn,options:[A,M]}};var KJ=(A,M)=>{let Z=yj(A);return{name:Z.name,fn:Z.fn,options:[A,M]}};var DJ=y(l(),1);var hj=Object.defineProperty,vj=(A,M)=>hj(A,"name",{value:M,configurable:!0});function gU(A){let[M,Z]=DJ.useState(void 0);return KA(()=>{if(A){Z({width:A.offsetWidth,height:A.offsetHeight});let q=new ResizeObserver((z)=>{if(!Array.isArray(z))return;if(!z.length)return;let Y=z[0],V,Q;if("borderBoxSize"in Y){let U=Y.borderBoxSize,B=Array.isArray(U)?U[0]:U;V=B.inlineSize,Q=B.blockSize}else V=A.offsetWidth,Q=A.offsetHeight;Z({width:V,height:Q})});return q.observe(A,{box:"border-box"}),()=>q.unobserve(A)}else Z(void 0)},[A]),M}vj(gU,"useSize");var Kz=y(uA(),1),fj=Object.defineProperty,bZ=(A,M)=>fj(A,"name",{value:M,configurable:!0});var NJ="Popper",[jJ,uU]=o7(NJ),[gj,XJ]=jJ(NJ),uj=bZ((A)=>{let{__scopePopper:M,children:Z}=A,[q,z]=YM.useState(null),[Y,V]=YM.useState(void 0);return Kz.jsx(gj,{scope:M,anchor:q,onAnchorChange:z,placementState:Y,setPlacementState:V,children:Z})},"Popper"),mj="PopperAnchor",dj=YM.forwardRef(bZ(function(M,Z){let{__scopePopper:q,virtualRef:z,...Y}=M,V=XJ(mj,q),Q=YM.useRef(null),U=V.onAnchorChange,B=YM.useCallback((O)=>{if(Q.current=O,O)U(O)},[U]),W=IA(Z,B),J=YM.useRef(null);YM.useEffect(()=>{if(!z)return;let O=J.current;if(J.current=z.current,O!==J.current)U(J.current)});let I=V.placementState&&o3(V.placementState),K=I?.[0],N=I?.[1];return z?null:Kz.jsx(wA.div,{"data-radix-popper-side":K,"data-radix-popper-align":N,...Y,ref:W})},"PopperAnchor")),OJ="PopperContent",[pj,nE]=jJ(OJ),cj=YM.forwardRef(bZ(function(M,Z){let{__scopePopper:q,side:z="bottom",sideOffset:Y=0,align:V="center",alignOffset:Q=0,arrowPadding:U=0,avoidCollisions:B=!0,collisionBoundary:W=[],collisionPadding:J=0,sticky:I="partial",hideWhenDetached:K=!1,updatePositionStrategy:N="optimized",onPlaced:O,...j}=M,T=XJ(OJ,q),[G,D]=YM.useState(null),X=IA(Z,D),[H,L]=YM.useState(null),F=gU(H),R=F?.width??0,k=F?.height??0,b=z+(V!=="center"?"-"+V:""),u=typeof J==="number"?J:{top:0,right:0,bottom:0,left:0,...J},h=Array.isArray(W)?W:[W],p=h.length>0,o={padding:u,boundary:h.filter(EJ),altBoundary:p},{refs:MA,floatingStyles:g,placement:i,isPositioned:m,middlewareData:ZA}=UJ({strategy:"fixed",placement:b,whileElementsMounted:bZ((...r)=>{return yU(...r,{animationFrame:N==="always"})},"whileElementsMounted"),elements:{reference:T.anchor},middleware:[BJ({mainAxis:Y+k,alignmentAxis:Q}),B&&GJ({mainAxis:!0,crossAxis:!1,limiter:I==="partial"?IJ():void 0,...o}),B&&WJ({...o}),JJ({...o,apply:bZ(({elements:r,rects:dA,availableWidth:YA,availableHeight:VA})=>{let{width:RA,height:WM}=dA.reference,gM=r.floating.style;gM.setProperty("--radix-popper-available-width",`${YA}px`),gM.setProperty("--radix-popper-available-height",`${VA}px`),gM.setProperty("--radix-popper-anchor-width",`${RA}px`),gM.setProperty("--radix-popper-anchor-height",`${WM}px`)},"apply")}),H&&KJ({element:H,padding:U}),lj({arrowWidth:R,arrowHeight:k}),K&&TJ({strategy:"referenceHidden",...o,boundary:p?o.boundary:void 0})]}),S=T.setPlacementState;KA(()=>{return S(i),()=>{S(void 0)}},[i,S]);let[hM,yA]=o3(i),qM=EM(O);KA(()=>{if(m)qM?.()},[m,qM]);let vM=ZA.arrow?.x,EA=ZA.arrow?.y,kA=ZA.arrow?.centerOffset!==0,[fM,d]=YM.useState();return KA(()=>{if(G)d(window.getComputedStyle(G).zIndex)},[G]),Kz.jsx("div",{ref:MA.setFloating,"data-radix-popper-content-wrapper":"",style:{...g,transform:m?g.transform:"translate(0, -200%)",minWidth:"max-content",zIndex:fM,"--radix-popper-transform-origin":[ZA.transformOrigin?.x,ZA.transformOrigin?.y].join(" "),...ZA.hide?.referenceHidden&&{visibility:"hidden",pointerEvents:"none"}},dir:M.dir,children:Kz.jsx(pj,{scope:q,placedSide:hM,placedAlign:yA,onArrowChange:L,arrowX:vM,arrowY:EA,shouldHideArrow:kA,children:Kz.jsx(wA.div,{"data-side":hM,"data-align":yA,...j,ref:X,style:{...j.style,animation:!m?"none":j.style?.animation}})})})},"PopperContent"));function EJ(A){return A!==null}bZ(EJ,"isNotNull");var lj=bZ((A)=>({name:"transformOrigin",options:A,fn(M){let{placement:Z,rects:q,middlewareData:z}=M,V=z.arrow?.centerOffset!==0,Q=V?0:A.arrowWidth,U=V?0:A.arrowHeight,[B,W]=o3(Z),J={start:"0%",center:"50%",end:"100%"}[W],I=(z.arrow?.x??0)+Q/2,K=(z.arrow?.y??0)+U/2,N="",O="";if(B==="bottom")N=V?J:`${I}px`,O=`${-U}px`;else if(B==="top")N=V?J:`${I}px`,O=`${q.floating.height+U}px`;else if(B==="right")N=`${-U}px`,O=V?J:`${K}px`;else if(B==="left")N=`${q.floating.width+U}px`,O=V?J:`${K}px`;return{data:{x:N,y:O}}}}),"transformOrigin");function o3(A){let[M,Z="center"]=A.split("-");return[M,Z]}bZ(o3,"getSideAndAlignFromPlacement");var RJ=uj,HJ=dj,FJ=cj;var a3=y(l(),1),LJ=y(Eq(),1);var wJ=y(uA(),1),rj=Object.defineProperty,sj=(A,M)=>rj(A,"name",{value:M,configurable:!0}),kJ=a3.forwardRef(sj(function(M,Z){let{container:q,...z}=M,[Y,V]=a3.useState(!1);KA(()=>V(!0),[]);let Q=q||Y&&globalThis?.document?.body;return Q?LJ.createPortal(wJ.jsx(wA.div,{...z,ref:Z}),Q):null},"Portal"));var ZM=y(l(),1);var CJ=y(l(),1),oj=Object.defineProperty,_7=(A,M)=>oj(A,"name",{value:M,configurable:!0});function bJ(A,M){return CJ.useReducer((Z,q)=>{return M[Z][q]??Z},A)}_7(bJ,"useStateMachine");var SJ=_7((A)=>{let{present:M,children:Z}=A,q=PJ(M),z=typeof Z==="function"?Z({present:q.isPresent}):ZM.Children.only(Z),Y=xJ(q.ref,yJ(z));return typeof Z==="function"||q.isPresent?ZM.cloneElement(z,{ref:Y}):null},"Presence");function PJ(A){let[M,Z]=ZM.useState(),q=ZM.useRef(null),z=ZM.useRef(A),Y=ZM.useRef("none"),V=ZM.useRef(void 0),Q=A?"mounted":"unmounted",[U,B]=bJ(Q,{mounted:{UNMOUNT:"unmounted",ANIMATION_OUT:"unmountSuspended"},unmountSuspended:{MOUNT:"mounted",ANIMATION_END:"unmounted"},unmounted:{MOUNT:"mounted"}});return ZM.useEffect(()=>{if(U==="mounted")Y.current=V.current??Dz(q.current),V.current=void 0;else Y.current="none"},[U]),KA(()=>{let W=q.current,J=z.current;if(J!==A){let K=Y.current,N=Dz(W);if(A)V.current=N,B("MOUNT");else if(N==="none"||W?.display==="none")B("UNMOUNT");else if(J&&K!==N)B("ANIMATION_OUT");else B("UNMOUNT");z.current=A}},[A,B]),KA(()=>{if(M){let W,J=M.ownerDocument.defaultView??window,I=_7((N)=>{let j=Dz(q.current).includes(CSS.escape(N.animationName));if(N.target===M&&j){if(B("ANIMATION_END"),!z.current){let T=M.style.animationFillMode;M.style.animationFillMode="forwards",W=J.setTimeout(()=>{if(M.style.animationFillMode==="forwards")M.style.animationFillMode=T})}}},"handleAnimationEnd"),K=_7((N)=>{if(N.target===M)Y.current=Dz(q.current)},"handleAnimationStart");return M.addEventListener("animationstart",K),M.addEventListener("animationcancel",I),M.addEventListener("animationend",I),()=>{J.clearTimeout(W),M.removeEventListener("animationstart",K),M.removeEventListener("animationcancel",I),M.removeEventListener("animationend",I)}}else B("ANIMATION_END")},[M,B]),{isPresent:["mounted","unmountSuspended"].includes(U),ref:ZM.useCallback((W)=>{if(W){let J=getComputedStyle(W);q.current=J,V.current=Dz(J)}else q.current=null;Z(W)},[])}}_7(PJ,"usePresence");function mU(A,M){if(typeof A==="function")return A(M);else if(A!==null&&A!==void 0)A.current=M}_7(mU,"setRef");function xJ(...A){let M=ZM.useRef(A);return M.current=A,ZM.useCallback((Z)=>{let q=M.current,z=!1,Y=q.map((V)=>{let Q=mU(V,Z);if(!z&&typeof Q==="function")z=!0;return Q});if(z)return()=>{for(let V=0;V<Y.length;V++){let Q=Y[V];if(typeof Q==="function")Q();else mU(q[V],null)}}},[])}_7(xJ,"useStableComposedRefs");function Dz(A){return A?.animationName||"none"}_7(Dz,"getAnimationName");function yJ(A){let M=Object.getOwnPropertyDescriptor(A.props,"ref")?.get,Z=M&&"isReactWarning"in M&&M.isReactWarning;if(Z)return A.ref;if(M=Object.getOwnPropertyDescriptor(A,"ref")?.get,Z=M&&"isReactWarning"in M&&M.isReactWarning,Z)return A.props.ref;return A.props.ref||A.ref}_7(yJ,"getElementRef");var eM=y(l(),1);var n3=!1;var G7=y(l(),1);var Nz=y(l(),1),aj=Object.defineProperty,nj=(A,M)=>aj(A,"name",{value:M,configurable:!0}),hJ=Nz[" useEffectEvent ".trim().toString()],vJ=Nz[" useInsertionEffect ".trim().toString()];function dU(A){if(typeof hJ==="function")return hJ(A);let M=Nz.useRef(()=>{throw Error("Cannot call an event handler while rendering.")});if(typeof vJ==="function")vJ(()=>{M.current=A});else KA(()=>{M.current=A});return Nz.useMemo(()=>(...Z)=>M.current?.(...Z),[])}nj(dU,"useEffectEvent");var $j=Object.defineProperty,dY=(A,M)=>$j(A,"name",{value:M,configurable:!0}),_j=eM[" useInsertionEffect ".trim().toString()]||KA;function $3({prop:A,defaultProp:M,onChange:Z=dY(()=>{},"onChange"),caller:q}){let[z,Y,V]=gJ({defaultProp:M,onChange:Z}),Q=A!==void 0,U=Q?A:z;if(n3){let W=eM.useRef(A!==void 0);eM.useEffect(()=>{let J=W.current;if(J!==Q)console.warn(`${q} is changing from ${J?"controlled":"uncontrolled"} to ${Q?"controlled":"uncontrolled"}. Components should not switch from controlled to uncontrolled (or vice versa). Decide between using a controlled or uncontrolled value for the lifetime of the component.`);W.current=Q},[Q,q])}let B=eM.useCallback((W)=>{if(Q){let J=uJ(W)?W(A):W;if(J!==A)V.current?.(J)}else Y(W)},[Q,A,Y,V]);return[U,B]}dY($3,"useControllableState");function gJ({defaultProp:A,onChange:M}){let[Z,q]=eM.useState(A),z=eM.useRef(Z),Y=eM.useRef(M);return _j(()=>{Y.current=M},[M]),eM.useEffect(()=>{if(z.current!==Z)Y.current?.(Z),z.current=Z},[Z,z]),[Z,q,Y]}dY(gJ,"useUncontrolledState");function uJ(A){return typeof A==="function"}dY(uJ,"isFunction");var fJ=Symbol("RADIX:SYNC_STATE");function tj(A,M,Z,q){let{prop:z,defaultProp:Y,onChange:V,caller:Q}=M,U=z!==void 0,B=dU(V);if(n3){let j=G7.useRef(z!==void 0);G7.useEffect(()=>{let T=j.current;if(T!==U)console.warn(`${Q} is changing from ${T?"controlled":"uncontrolled"} to ${U?"controlled":"uncontrolled"}. Components should not switch from controlled to uncontrolled (or vice versa). Decide between using a controlled or uncontrolled value for the lifetime of the component.`);j.current=U},[U,Q])}let W=[{...Z,state:Y}];if(q)W.push(q);let[J,I]=G7.useReducer((j,T)=>{if(T.type===fJ)return{...j,state:T.state};let G=A(j,T);if(U&&!Object.is(G.state,j.state))B(G.state);return G},...W),K=J.state,N=G7.useRef(K);G7.useEffect(()=>{if(N.current!==K){if(N.current=K,!U)B(K)}},[K,N,U]);let O=G7.useMemo(()=>{if(z!==void 0)return{...J,state:z};return J},[J,z]);return G7.useEffect(()=>{if(U&&!Object.is(z,J.state))I({type:fJ,state:z})},[z,J.state,U]),[O,I]}dY(tj,"useControllableStateReducer");var _3=y(l(),1),ej=Object.defineProperty,AX=(A,M)=>ej(A,"name",{value:M,configurable:!0});function pU(A){let M=_3.useRef({value:A,previous:A});return _3.useMemo(()=>{if(M.current.value!==A)M.current.previous=M.current.value,M.current.value=A;return M.current.previous},[A])}AX(pU,"usePrevious");var MX=y(l(),1);var ZX=y(uA(),1);var mJ=Object.freeze({position:"absolute",border:0,width:1,height:1,padding:0,margin:-1,overflow:"hidden",clip:"rect(0, 0, 0, 0)",whiteSpace:"nowrap",wordWrap:"normal"});var qX=function(A){if(typeof document>"u")return null;var M=Array.isArray(A)?A[0]:A;return M.ownerDocument.body},jz=new WeakMap,t3=new WeakMap,e3={},cU=0,dJ=function(A){return A&&(A.host||dJ(A.parentNode))},zX=function(A,M){return M.map(function(Z){if(A.contains(Z))return Z;var q=dJ(Z);if(q&&A.contains(q))return q;return console.error("aria-hidden",Z,"in not contained inside",A,". Doing nothing"),null}).filter(function(Z){return Boolean(Z)})},YX=function(A,M,Z,q){var z=zX(M,Array.isArray(A)?A:[A]);if(!e3[Z])e3[Z]=new WeakMap;var Y=e3[Z],V=[],Q=new Set,U=new Set(z),B=function(J){if(!J||Q.has(J))return;Q.add(J),B(J.parentNode)};z.forEach(B);var W=function(J){if(!J||U.has(J))return;Array.prototype.forEach.call(J.children,function(I){if(Q.has(I))W(I);else try{var K=I.getAttribute(q),N=K!==null&&K!=="false",O=(jz.get(I)||0)+1,j=(Y.get(I)||0)+1;if(jz.set(I,O),Y.set(I,j),V.push(I),O===1&&N)t3.set(I,!0);if(j===1)I.setAttribute(Z,"true");if(!N)I.setAttribute(q,"true")}catch(T){console.error("aria-hidden: cannot operate on ",I,T)}})};return W(M),Q.clear(),cU++,function(){if(V.forEach(function(J){var I=jz.get(J)-1,K=Y.get(J)-1;if(jz.set(J,I),Y.set(J,K),!I){if(!t3.has(J))J.removeAttribute(q);t3.delete(J)}if(!K)J.removeAttribute(Z)}),cU--,!cU)jz=new WeakMap,jz=new WeakMap,t3=new WeakMap,e3={}}},pJ=function(A,M,Z){if(Z===void 0)Z="data-aria-hidden";var q=Array.from(Array.isArray(A)?A:[A]),z=M||qX(A);if(!z)return function(){return null};return q.push.apply(q,Array.from(z.querySelectorAll("[aria-live], script"))),YX(q,z,Z,"aria-hidden")};var RM=function(){return RM=Object.assign||function(M){for(var Z,q=1,z=arguments.length;q<z;q++){Z=arguments[q];for(var Y in Z)if(Object.prototype.hasOwnProperty.call(Z,Y))M[Y]=Z[Y]}return M},RM.apply(this,arguments)};function AV(A,M){var Z={};for(var q in A)if(Object.prototype.hasOwnProperty.call(A,q)&&M.indexOf(q)<0)Z[q]=A[q];if(A!=null&&typeof Object.getOwnPropertySymbols==="function"){for(var z=0,q=Object.getOwnPropertySymbols(A);z<q.length;z++)if(M.indexOf(q[z])<0&&Object.prototype.propertyIsEnumerable.call(A,q[z]))Z[q[z]]=A[q[z]]}return Z}function cJ(A,M,Z){if(Z||arguments.length===2){for(var q=0,z=M.length,Y;q<z;q++)if(Y||!(q in M)){if(!Y)Y=Array.prototype.slice.call(M,0,q);Y[q]=M[q]}}return A.concat(Y||Array.prototype.slice.call(M))}var YV=y(l(),1);var VM=y(l(),1);var Gq="right-scroll-bar-position",Iq="width-before-scroll-bar",lU="with-scroll-bars-hidden",iU="--removed-body-scroll-bar-size";function MV(A,M){if(typeof A==="function")A(M);else if(A)A.current=M;return A}var lJ=y(l(),1);function iJ(A,M){var Z=lJ.useState(function(){return{value:A,callback:M,facade:{get current(){return Z.value},set current(q){var z=Z.value;if(z!==q)Z.value=q,Z.callback(q,z)}}}})[0];return Z.callback=M,Z.facade}var ZV=y(l(),1);var VX=typeof window<"u"?ZV.useLayoutEffect:ZV.useEffect,rJ=new WeakMap;function rU(A,M){var Z=iJ(M||null,function(q){return A.forEach(function(z){return MV(z,q)})});return VX(function(){var q=rJ.get(Z);if(q){var z=new Set(q),Y=new Set(A),V=Z.current;z.forEach(function(Q){if(!Y.has(Q))MV(Q,null)}),Y.forEach(function(Q){if(!z.has(Q))MV(Q,V)})}rJ.set(Z,A)},[A]),Z}function QX(A){return A}function UX(A,M){if(M===void 0)M=QX;var Z=[],q=!1,z={read:function(){if(q)throw Error("Sidecar: could not `read` from an `assigned` medium. `read` could be used only with `useMedium`.");if(Z.length)return Z[Z.length-1];return A},useMedium:function(Y){var V=M(Y,q);return Z.push(V),function(){Z=Z.filter(function(Q){return Q!==V})}},assignSyncMedium:function(Y){q=!0;while(Z.length){var V=Z;Z=[],V.forEach(Y)}Z={push:function(Q){return Y(Q)},filter:function(){return Z}}},assignMedium:function(Y){q=!0;var V=[];if(Z.length){var Q=Z;Z=[],Q.forEach(Y),V=Z}var U=function(){var W=V;V=[],W.forEach(Y)},B=function(){return Promise.resolve().then(U)};B(),Z={push:function(W){V.push(W),B()},filter:function(W){return V=V.filter(W),Z}}}};return z}function sU(A){if(A===void 0)A={};var M=UX(null);return M.options=RM({async:!0,ssr:!1},A),M}var sJ=y(l(),1),oJ=function(A){var M=A.sideCar,Z=AV(A,["sideCar"]);if(!M)throw Error("Sidecar: please provide `sideCar` property to import the right car");var q=M.read();if(!q)throw Error("Sidecar medium not found");return sJ.createElement(q,RM({},Z))};oJ.isSideCarExport=!0;function oU(A,M){return A.useMedium(M),oJ}var qV=sU();var aU=function(){return},pY=VM.forwardRef(function(A,M){var Z=VM.useRef(null),q=VM.useState({onScrollCapture:aU,onWheelCapture:aU,onTouchMoveCapture:aU}),z=q[0],Y=q[1],V=A.forwardProps,Q=A.children,U=A.className,B=A.removeScrollBar,W=A.enabled,J=A.shards,I=A.sideCar,K=A.noRelative,N=A.noIsolation,O=A.inert,j=A.allowPinchZoom,T=A.as,G=T===void 0?"div":T,D=A.gapMode,X=AV(A,["forwardProps","children","className","removeScrollBar","enabled","shards","sideCar","noRelative","noIsolation","inert","allowPinchZoom","as","gapMode"]),H=I,L=rU([Z,M]),F=RM(RM({},X),z);return VM.createElement(VM.Fragment,null,W&&VM.createElement(H,{sideCar:qV,removeScrollBar:B,shards:J,noRelative:K,noIsolation:N,inert:O,setCallbacks:Y,allowPinchZoom:!!j,lockRef:Z,gapMode:D}),V?VM.cloneElement(VM.Children.only(Q),RM(RM({},F),{ref:L})):VM.createElement(G,RM({},F,{className:U,ref:L}),Q))});pY.defaultProps={enabled:!0,removeScrollBar:!0,inert:!1};pY.classNames={fullWidth:Iq,zeroRight:Gq};var OA=y(l(),1);var Oz=y(l(),1);var $J=y(l(),1);var aJ;var nJ=function(){if(aJ)return aJ;if(typeof __webpack_nonce__<"u")return __webpack_nonce__;return};function BX(){if(!document)return null;var A=document.createElement("style");A.type="text/css";var M=nJ();if(M)A.setAttribute("nonce",M);return A}function GX(A,M){if(A.styleSheet)A.styleSheet.cssText=M;else A.appendChild(document.createTextNode(M))}function IX(A){var M=document.head||document.getElementsByTagName("head")[0];M.appendChild(A)}var nU=function(){var A=0,M=null;return{add:function(Z){if(A==0){if(M=BX())GX(M,Z),IX(M)}A++},remove:function(){if(A--,!A&&M)M.parentNode&&M.parentNode.removeChild(M),M=null}}};var $U=function(){var A=nU();return function(M,Z){$J.useEffect(function(){return A.add(M),function(){A.remove()}},[M&&Z])}};var cY=function(){var A=$U(),M=function(Z){var{styles:q,dynamic:z}=Z;return A(q,z),null};return M};var WX={left:0,top:0,right:0,gap:0},_U=function(A){return parseInt(A||"",10)||0},JX=function(A){var M=window.getComputedStyle(document.body),Z=M[A==="padding"?"paddingLeft":"marginLeft"],q=M[A==="padding"?"paddingTop":"marginTop"],z=M[A==="padding"?"paddingRight":"marginRight"];return[_U(Z),_U(q),_U(z)]},tU=function(A){if(A===void 0)A="margin";if(typeof window>"u")return WX;var M=JX(A),Z=document.documentElement.clientWidth,q=window.innerWidth;return{left:M[0],top:M[1],right:M[2],gap:Math.max(0,q-Z+M[2]-M[0])}};var TX=cY(),Xz="data-scroll-locked",KX=function(A,M,Z,q){var{left:z,top:Y,right:V,gap:Q}=A;if(Z===void 0)Z="margin";return`
  .`.concat(lU,` {
   overflow: hidden `).concat(q,`;
   padding-right: `).concat(Q,"px ").concat(q,`;
  }
  body[`).concat(Xz,`] {
    overflow: hidden `).concat(q,`;
    overscroll-behavior: contain;
    `).concat([M&&"position: relative ".concat(q,";"),Z==="margin"&&`
    padding-left: `.concat(z,`px;
    padding-top: `).concat(Y,`px;
    padding-right: `).concat(V,`px;
    margin-left:0;
    margin-top:0;
    margin-right: `).concat(Q,"px ").concat(q,`;
    `),Z==="padding"&&"padding-right: ".concat(Q,"px ").concat(q,";")].filter(Boolean).join(""),`
  }
  
  .`).concat(Gq,` {
    right: `).concat(Q,"px ").concat(q,`;
  }
  
  .`).concat(Iq,` {
    margin-right: `).concat(Q,"px ").concat(q,`;
  }
  
  .`).concat(Gq," .").concat(Gq,` {
    right: 0 `).concat(q,`;
  }
  
  .`).concat(Iq," .").concat(Iq,` {
    margin-right: 0 `).concat(q,`;
  }
  
  body[`).concat(Xz,`] {
    `).concat(iU,": ").concat(Q,`px;
  }
`)},_J=function(){var A=parseInt(document.body.getAttribute(Xz)||"0",10);return isFinite(A)?A:0},DX=function(){Oz.useEffect(function(){return document.body.setAttribute(Xz,(_J()+1).toString()),function(){var A=_J()-1;if(A<=0)document.body.removeAttribute(Xz);else document.body.setAttribute(Xz,A.toString())}},[])},eU=function(A){var{noRelative:M,noImportant:Z,gapMode:q}=A,z=q===void 0?"margin":q;DX();var Y=Oz.useMemo(function(){return tU(z)},[z]);return Oz.createElement(TX,{styles:KX(Y,!M,z,!Z?"!important":"")})};var A1=!1;if(typeof window<"u")try{Ez=Object.defineProperty({},"passive",{get:function(){return A1=!0,!0}}),window.addEventListener("test",Ez,Ez),window.removeEventListener("test",Ez,Ez)}catch(A){A1=!1}var Ez,Wq=A1?{passive:!1}:!1;var NX=function(A){return A.tagName==="TEXTAREA"},tJ=function(A,M){if(!(A instanceof Element))return!1;var Z=window.getComputedStyle(A);return Z[M]!=="hidden"&&!(Z.overflowY===Z.overflowX&&!NX(A)&&Z[M]==="visible")},jX=function(A){return tJ(A,"overflowY")},XX=function(A){return tJ(A,"overflowX")},M1=function(A,M){var Z=M.ownerDocument,q=M;do{if(typeof ShadowRoot<"u"&&q instanceof ShadowRoot)q=q.host;var z=eJ(A,q);if(z){var Y=AT(A,q),V=Y[1],Q=Y[2];if(V>Q)return!0}q=q.parentNode}while(q&&q!==Z.body);return!1},OX=function(A){var{scrollTop:M,scrollHeight:Z,clientHeight:q}=A;return[M,Z,q]},EX=function(A){var{scrollLeft:M,scrollWidth:Z,clientWidth:q}=A;return[M,Z,q]},eJ=function(A,M){return A==="v"?jX(M):XX(M)},AT=function(A,M){return A==="v"?OX(M):EX(M)},RX=function(A,M){return A==="h"&&M==="rtl"?-1:1},MT=function(A,M,Z,q,z){var Y=RX(A,window.getComputedStyle(M).direction),V=Y*q,Q=Z.target,U=M.contains(Q),B=!1,W=V>0,J=0,I=0;do{if(!Q)break;var K=AT(A,Q),N=K[0],O=K[1],j=K[2],T=O-j-Y*N;if(N||T){if(eJ(A,Q))J+=T,I+=N}var G=Q.parentNode;Q=G&&G.nodeType===Node.DOCUMENT_FRAGMENT_NODE?G.host:G}while(!U&&Q!==document.body||U&&(M.contains(Q)||M===Q));if(W&&(z&&Math.abs(J)<1||!z&&V>J))B=!0;else if(!W&&(z&&Math.abs(I)<1||!z&&-V>I))B=!0;return B};var zV=function(A){return"changedTouches"in A?[A.changedTouches[0].clientX,A.changedTouches[0].clientY]:[0,0]},ZT=function(A){return[A.deltaX,A.deltaY]},qT=function(A){return A&&"current"in A?A.current:A},HX=function(A,M){return A[0]===M[0]&&A[1]===M[1]},FX=function(A){return`
  .block-interactivity-`.concat(A,` {pointer-events: none;}
  .allow-interactivity-`).concat(A,` {pointer-events: all;}
`)},LX=0,Rz=[];function zT(A){var M=OA.useRef([]),Z=OA.useRef([0,0]),q=OA.useRef(),z=OA.useState(LX++)[0],Y=OA.useState(cY)[0],V=OA.useRef(A);OA.useEffect(function(){V.current=A},[A]),OA.useEffect(function(){if(A.inert){document.body.classList.add("block-interactivity-".concat(z));var O=cJ([A.lockRef.current],(A.shards||[]).map(qT),!0).filter(Boolean);return O.forEach(function(j){return j.classList.add("allow-interactivity-".concat(z))}),function(){document.body.classList.remove("block-interactivity-".concat(z)),O.forEach(function(j){return j.classList.remove("allow-interactivity-".concat(z))})}}return},[A.inert,A.lockRef.current,A.shards]);var Q=OA.useCallback(function(O,j){if("touches"in O&&O.touches.length===2||O.type==="wheel"&&O.ctrlKey)return!V.current.allowPinchZoom;var T=zV(O),G=Z.current,D="deltaX"in O?O.deltaX:G[0]-T[0],X="deltaY"in O?O.deltaY:G[1]-T[1],H,L=O.target,F=Math.abs(D)>Math.abs(X)?"h":"v";if("touches"in O&&F==="h"&&L.type==="range")return!1;var R=window.getSelection(),k=R&&R.anchorNode,b=k?k===L||k.contains(L):!1;if(b)return!1;var u=M1(F,L);if(!u)return!0;if(u)H=F;else H=F==="v"?"h":"v",u=M1(F,L);if(!u)return!1;if(!q.current&&"changedTouches"in O&&(D||X))q.current=H;if(!H)return!0;var h=q.current||H;return MT(h,j,O,h==="h"?D:X,!0)},[]),U=OA.useCallback(function(O){var j=O;if(!Rz.length||Rz[Rz.length-1]!==Y)return;var T="deltaY"in j?ZT(j):zV(j),G=M.current.filter(function(H){return H.name===j.type&&(H.target===j.target||j.target===H.shadowParent)&&HX(H.delta,T)})[0];if(G&&G.should){if(j.cancelable)j.preventDefault();return}if(!G){var D=(V.current.shards||[]).map(qT).filter(Boolean).filter(function(H){return H.contains(j.target)}),X=D.length>0?Q(j,D[0]):!V.current.noIsolation;if(X){if(j.cancelable)j.preventDefault()}}},[]),B=OA.useCallback(function(O,j,T,G){var D={name:O,delta:j,target:T,should:G,shadowParent:wX(T)};M.current.push(D),setTimeout(function(){M.current=M.current.filter(function(X){return X!==D})},1)},[]),W=OA.useCallback(function(O){Z.current=zV(O),q.current=void 0},[]),J=OA.useCallback(function(O){B(O.type,ZT(O),O.target,Q(O,A.lockRef.current))},[]),I=OA.useCallback(function(O){B(O.type,zV(O),O.target,Q(O,A.lockRef.current))},[]);OA.useEffect(function(){return Rz.push(Y),A.setCallbacks({onScrollCapture:J,onWheelCapture:J,onTouchMoveCapture:I}),document.addEventListener("wheel",U,Wq),document.addEventListener("touchmove",U,Wq),document.addEventListener("touchstart",W,Wq),function(){Rz=Rz.filter(function(O){return O!==Y}),document.removeEventListener("wheel",U,Wq),document.removeEventListener("touchmove",U,Wq),document.removeEventListener("touchstart",W,Wq)}},[]);var{removeScrollBar:K,inert:N}=A;return OA.createElement(OA.Fragment,null,N?OA.createElement(Y,{styles:FX(z)}):null,K?OA.createElement(eU,{noRelative:A.noRelative,gapMode:A.gapMode}):null)}function wX(A){var M=null;while(A!==null){if(A instanceof ShadowRoot)M=A.host,A=A.host;A=A.parentNode}return M}var YT=oU(qV,zT);var VT=YV.forwardRef(function(A,M){return YV.createElement(pY,RM({},A,{ref:M,sideCar:YT}))});VT.classNames=pY.classNames;var Z1=VT;var v=y(uA(),1),kX=Object.defineProperty,AA=(A,M)=>kX(A,"name",{value:M,configurable:!0}),CX=[" ","Enter","ArrowUp","ArrowDown"],bX=[" ","Enter"],Hz="Select",[QV,UV,SX]=JU(Hz),[Tq,l4]=o7(Hz,[SX,uU]),Y1=uU(),[PX,SZ]=Tq(Hz),[xX,yX]=Tq(Hz);function IT(A){let{__scopeSelect:M,children:Z,open:q,defaultOpen:z,onOpenChange:Y,value:V,defaultValue:Q,onValueChange:U,dir:B,name:W,autoComplete:J,disabled:I,required:K,form:N,internal_do_not_use_render:O}=A,j=Y1(M),[T,G]=C.useState(null),[D,X]=C.useState(null),[H,L]=C.useState(!1),F=KU(B),[R,k]=$3({prop:q,defaultProp:z??!1,onChange:Y,caller:Hz}),[b,u]=$3({prop:V,defaultProp:Q,onChange:U,caller:Hz}),h=C.useRef(null),p=C.useRef(b);C.useEffect(()=>{let yA=N?T?.ownerDocument.getElementById(N):T?.form;if(yA instanceof HTMLFormElement){let qM=AA(()=>u(p.current),"reset");return yA.addEventListener("reset",qM),()=>yA.removeEventListener("reset",qM)}},[N,T,u]);let o=T?!!N||!!T.closest("form"):!0,[MA,g]=C.useState(new Set),i=v3(),m=Array.from(MA).map((yA)=>yA.props.value).join(";"),ZA=C.useCallback((yA)=>{g((qM)=>new Set(qM).add(yA))},[]),S=C.useCallback((yA)=>{g((qM)=>{let vM=new Set(qM);return vM.delete(yA),vM})},[]),hM={required:K,trigger:T,onTriggerChange:G,valueNode:D,onValueNodeChange:X,valueNodeHasChildren:H,onValueNodeHasChildrenChange:L,contentId:i,value:b,onValueChange:u,open:R,onOpenChange:k,dir:F,triggerPointerDownPosRef:h,disabled:I,name:W,autoComplete:J,form:N,nativeOptions:MA,nativeSelectKey:m,isFormControl:o};return v.jsx(RJ,{...j,children:v.jsx(PX,{scope:M,...hM,children:v.jsx(QV.Provider,{scope:M,children:v.jsx(xX,{scope:M,onNativeOptionAdd:ZA,onNativeOptionRemove:S,children:RT(O)?O(hM):Z})})})})}AA(IT,"SelectProvider");var WT=AA((A)=>{let{__scopeSelect:M,children:Z,...q}=A;return v.jsx(IT,{__scopeSelect:M,...q,internal_do_not_use_render:({isFormControl:z})=>v.jsxs(v.Fragment,{children:[Z,z?v.jsx($X,{__scopeSelect:M}):null]})})},"Select"),hX="SelectTrigger",V1=C.forwardRef(AA(function(M,Z){let{__scopeSelect:q,disabled:z=!1,...Y}=M,V=Y1(q),Q=SZ(hX,q),U=Q.disabled||z,B=IA(Z,Q.onTriggerChange),W=UV(q),J=C.useRef("touch"),[I,K,N]=T1((j)=>{let T=W().filter((X)=>!X.disabled),G=T.find((X)=>X.value===Q.value),D=K1(T,j,G);if(D!==void 0)Q.onValueChange(D.value)}),O=AA((j)=>{if(!U)Q.onOpenChange(!0),N();if(j)Q.triggerPointerDownPosRef.current={x:Math.round(j.pageX),y:Math.round(j.pageY)}},"handleOpen");return v.jsx(HJ,{asChild:!0,...V,children:v.jsx(wA.button,{type:"button",role:"combobox","aria-controls":Q.open?Q.contentId:void 0,"aria-expanded":Q.open,"aria-required":Q.required,"aria-autocomplete":"none",dir:Q.dir,"data-state":Q.open?"open":"closed",disabled:U,"data-disabled":U?"":void 0,"data-placeholder":lY(Q.value)?"":void 0,...Y,ref:B,onClick:LA(Y.onClick,(j)=>{if(j.currentTarget.focus(),J.current!=="mouse")O(j)}),onPointerDown:LA(Y.onPointerDown,(j)=>{J.current=j.pointerType;let T=j.target;if(T.hasPointerCapture(j.pointerId))T.releasePointerCapture(j.pointerId);if(j.button===0&&j.ctrlKey===!1&&j.pointerType==="mouse")O(j),j.preventDefault()}),onKeyDown:LA(Y.onKeyDown,(j)=>{let T=I.current!=="";if(!(j.ctrlKey||j.altKey||j.metaKey)&&j.key.length===1)K(j.key);if(T&&j.key===" ")return;if(CX.includes(j.key))O(),j.preventDefault()})})})},"SelectTrigger")),vX="SelectValue",JT=C.forwardRef(AA(function(M,Z){let{__scopeSelect:q,className:z,style:Y,children:V,placeholder:Q="",...U}=M,B=SZ(vX,q),{onValueNodeHasChildrenChange:W}=B,J=V!==void 0,I=IA(Z,B.onValueNodeChange);KA(()=>{W(J)},[W,J]);let K=lY(B.value);return v.jsx(wA.span,{...U,asChild:K?!1:U.asChild,ref:I,style:{pointerEvents:"none"},children:v.jsx(C.Fragment,{children:K?Q:V},K?"placeholder":"value")})},"SelectValue")),TT=C.forwardRef(AA(function(M,Z){let{__scopeSelect:q,children:z,...Y}=M;return v.jsx(wA.span,{"aria-hidden":!0,...Y,ref:Z,children:z||"▼"})},"SelectIcon")),fX="SelectPortal",[gX,uX]=Tq(fX,{forceMount:void 0}),KT=AA((A)=>{let{__scopeSelect:M,forceMount:Z,...q}=A;return v.jsx(gX,{scope:A.__scopeSelect,forceMount:Z,children:v.jsx(kJ,{asChild:!0,...q})})},"SelectPortal"),Jq="SelectContent",Q1=C.forwardRef(AA(function(M,Z){let q=uX(Jq,M.__scopeSelect),{forceMount:z=q.forceMount,...Y}=M,V=SZ(Jq,M.__scopeSelect),[Q,U]=C.useState();return KA(()=>{U(new DocumentFragment)},[]),v.jsx(SJ,{present:z||V.open,children:({present:B})=>B?v.jsx(pX,{...Y,ref:Z}):v.jsx(mX,{...Y,fragment:Q})})},"SelectContent")),mX=C.forwardRef(AA(function(M,Z){let{__scopeSelect:q,children:z,fragment:Y}=M;if(!Y)return null;return z1.createPortal(v.jsx(DT,{scope:q,children:v.jsx(QV.Slot,{scope:q,children:v.jsx("div",{ref:Z,children:z})})}),Y)},"SelectContentFragment")),I7=10,[DT,Kq]=Tq(Jq),dX=nM("SelectContent.RemoveScroll"),pX=C.forwardRef(AA(function(M,Z){let{__scopeSelect:q}=M,{position:z="item-aligned",onCloseAutoFocus:Y,onEscapeKeyDown:V,onPointerDownOutside:Q,side:U,sideOffset:B,align:W,alignOffset:J,arrowPadding:I,collisionBoundary:K,collisionPadding:N,sticky:O,hideWhenDetached:j,avoidCollisions:T,...G}=M,D=SZ(Jq,q),[X,H]=C.useState(null),[L,F]=C.useState(null),R=IA(Z,H),[k,b]=C.useState(null),[u,h]=C.useState(null),p=UV(q),[o,MA]=C.useState(!1),g=C.useRef(!1);C.useEffect(()=>{if(X)return pJ(X)},[X]),h3();let i=C.useCallback((d)=>{let[r,...dA]=p().map((RA)=>RA.ref.current),[YA]=dA.slice(-1),VA=document.activeElement;for(let RA of d){if(RA===VA)return;if(RA?.scrollIntoView({block:"nearest"}),RA===r&&L)L.scrollTop=0;if(RA===YA&&L)L.scrollTop=L.scrollHeight;if(RA?.focus(),document.activeElement!==VA)return}},[p,L]),m=C.useCallback(()=>i([k,X]),[i,k,X]);C.useEffect(()=>{if(o)m()},[o,m]);let{onOpenChange:ZA,triggerPointerDownPosRef:S}=D;C.useEffect(()=>{if(X){let d={x:0,y:0},r=AA((YA)=>{d={x:Math.abs(Math.round(YA.pageX)-(S.current?.x??0)),y:Math.abs(Math.round(YA.pageY)-(S.current?.y??0))}},"handlePointerMove"),dA=AA((YA)=>{if(d.x<=10&&d.y<=10)YA.preventDefault();else if(!YA.composedPath().includes(X))ZA(!1);document.removeEventListener("pointermove",r),S.current=null},"handlePointerUp");if(S.current!==null)document.addEventListener("pointermove",r),document.addEventListener("pointerup",dA,{capture:!0,once:!0});return()=>{document.removeEventListener("pointermove",r),document.removeEventListener("pointerup",dA,{capture:!0})}}},[X,ZA,S]),C.useEffect(()=>{let d=AA(()=>ZA(!1),"close");return window.addEventListener("blur",d),window.addEventListener("resize",d),()=>{window.removeEventListener("blur",d),window.removeEventListener("resize",d)}},[ZA]);let[hM,yA]=T1((d)=>{let r=p().filter((VA)=>!VA.disabled),dA=r.find((VA)=>VA.ref.current===document.activeElement),YA=K1(r,d,dA);if(YA)setTimeout(()=>YA.ref.current?.focus())}),qM=C.useCallback((d,r,dA)=>{let YA=!g.current&&!dA;if(D.value!==void 0&&D.value===r||YA){if(b(d),YA)g.current=!0}},[D.value]),vM=C.useCallback(()=>X?.focus(),[X]),EA=C.useCallback((d,r,dA)=>{let YA=!g.current&&!dA;if(D.value!==void 0&&D.value===r||YA)h(d)},[D.value]),kA=z==="popper"?QT:cX,fM=kA===QT?{side:U,sideOffset:B,align:W,alignOffset:J,arrowPadding:I,collisionBoundary:K,collisionPadding:N,sticky:O,hideWhenDetached:j,avoidCollisions:T}:{};return v.jsx(DT,{scope:q,content:X,viewport:L,onViewportChange:F,itemRefCallback:qM,selectedItem:k,onItemLeave:vM,itemTextRefCallback:EA,focusSelectedItem:m,selectedItemText:u,position:z,isPositioned:o,searchRef:hM,children:v.jsx(Z1,{as:dX,allowPinchZoom:!0,children:v.jsx(W6,{asChild:!0,trapped:D.open,onMountAutoFocus:(d)=>{d.preventDefault()},onUnmountAutoFocus:LA(Y,(d)=>{D.trigger?.focus({preventScroll:!0}),d.preventDefault()}),children:v.jsx(Y6,{asChild:!0,disableOutsidePointerEvents:!0,onEscapeKeyDown:V,onPointerDownOutside:Q,onFocusOutside:(d)=>d.preventDefault(),onDismiss:()=>D.onOpenChange(!1),children:v.jsx(kA,{role:"listbox",id:D.contentId,"data-state":D.open?"open":"closed",dir:D.dir,onContextMenu:(d)=>d.preventDefault(),...G,...fM,onPlaced:()=>MA(!0),ref:R,style:{display:"flex",flexDirection:"column",outline:"none",...G.style},onKeyDown:LA(G.onKeyDown,(d)=>{let r=d.ctrlKey||d.altKey||d.metaKey;if(d.key==="Tab")d.preventDefault();if(!r&&d.key.length===1)yA(d.key);if(["ArrowUp","ArrowDown","Home","End"].includes(d.key)){let YA=p().filter((VA)=>!VA.disabled).map((VA)=>VA.ref.current);if(["ArrowUp","End"].includes(d.key))YA=YA.slice().reverse();if(["ArrowUp","ArrowDown"].includes(d.key)){let VA=d.target,RA=YA.indexOf(VA);YA=YA.slice(RA+1)}setTimeout(()=>i(YA)),d.preventDefault()}})})})})})})},"SelectContentImpl")),cX=C.forwardRef(AA(function(M,Z){let{__scopeSelect:q,onPlaced:z,...Y}=M,V=SZ(Jq,q),Q=Kq(Jq,q),[U,B]=C.useState(null),[W,J]=C.useState(null),I=IA(Z,J),K=UV(q),N=C.useRef(!1),O=C.useRef(!0),{viewport:j,selectedItem:T,selectedItemText:G,focusSelectedItem:D}=Q,X=C.useCallback(()=>{if(V.trigger&&V.valueNode&&U&&W&&j&&T&&G){let R=V.trigger.getBoundingClientRect(),k=W.getBoundingClientRect(),b=V.valueNode.getBoundingClientRect(),u=G.getBoundingClientRect();if(V.dir!=="rtl"){let VA=u.left-k.left,RA=b.left-VA,WM=R.left-RA,gM=R.width+WM,JV=Math.max(gM,k.width),TV=window.innerWidth-I7,KV=b3(RA,[I7,Math.max(I7,TV-JV)]);U.style.minWidth=gM+"px",U.style.left=KV+"px"}else{let VA=k.right-u.right,RA=window.innerWidth-b.right-VA,WM=window.innerWidth-R.right-RA,gM=R.width+WM,JV=Math.max(gM,k.width),TV=window.innerWidth-I7,KV=b3(RA,[I7,Math.max(I7,TV-JV)]);U.style.minWidth=gM+"px",U.style.right=KV+"px"}let h=K(),p=window.innerHeight-I7*2,o=j.scrollHeight,MA=window.getComputedStyle(W),g=parseInt(MA.borderTopWidth,10),i=parseInt(MA.paddingTop,10),m=parseInt(MA.borderBottomWidth,10),ZA=parseInt(MA.paddingBottom,10),S=g+i+o+ZA+m,hM=Math.min(T.offsetHeight*5,S),yA=window.getComputedStyle(j),qM=parseInt(yA.paddingTop,10),vM=parseInt(yA.paddingBottom,10),EA=R.top+R.height/2-I7,kA=p-EA,fM=T.offsetHeight/2,d=T.offsetTop+fM,r=g+i+d,dA=S-r;if(r<=EA){let VA=h.length>0&&T===h[h.length-1].ref.current;U.style.bottom="0px";let RA=W.clientHeight-j.offsetTop-j.offsetHeight,WM=Math.max(kA,fM+(VA?vM:0)+RA+m),gM=r+WM;U.style.height=gM+"px"}else{let VA=h.length>0&&T===h[0].ref.current;U.style.top="0px";let WM=Math.max(EA,g+j.offsetTop+(VA?qM:0)+fM)+dA;U.style.height=WM+"px",j.scrollTop=r-EA+j.offsetTop}U.style.margin=`${I7}px 0`,U.style.minHeight=hM+"px",U.style.maxHeight=p+"px",z?.(),requestAnimationFrame(()=>N.current=!0)}},[K,V.trigger,V.valueNode,U,W,j,T,G,V.dir,z]);KA(()=>X(),[X]);let[H,L]=C.useState();KA(()=>{if(W)L(window.getComputedStyle(W).zIndex)},[W]);let F=C.useCallback((R)=>{if(R&&O.current===!0)X(),D?.(),O.current=!1},[X,D]);return v.jsx(lX,{scope:q,contentWrapper:U,shouldExpandOnScrollRef:N,onScrollButtonChange:F,children:v.jsx("div",{ref:B,style:{display:"flex",flexDirection:"column",position:"fixed",zIndex:H},children:v.jsx(wA.div,{...Y,ref:I,style:{boxSizing:"border-box",maxHeight:"100%",...Y.style}})})})},"SelectItemAlignedPosition")),QT=C.forwardRef(AA(function(M,Z){let{__scopeSelect:q,align:z="start",collisionPadding:Y=I7,...V}=M,Q=Y1(q);return v.jsx(FJ,{...Q,...V,ref:Z,align:z,collisionPadding:Y,style:{boxSizing:"border-box",...V.style,...{"--radix-select-content-transform-origin":"var(--radix-popper-transform-origin)","--radix-select-content-available-width":"var(--radix-popper-available-width)","--radix-select-content-available-height":"var(--radix-popper-available-height)","--radix-select-trigger-width":"var(--radix-popper-anchor-width)","--radix-select-trigger-height":"var(--radix-popper-anchor-height)"}}})},"SelectPopperPosition")),[lX,U1]=Tq(Jq,{}),UT="SelectViewport",NT=C.forwardRef(AA(function(M,Z){let{__scopeSelect:q,nonce:z,...Y}=M,V=Kq(UT,q),Q=U1(UT,q),U=IA(Z,V.onViewportChange),B=C.useRef(0);return v.jsxs(v.Fragment,{children:[v.jsx("style",{dangerouslySetInnerHTML:{__html:"[data-radix-select-viewport]{scrollbar-width:none;-ms-overflow-style:none;-webkit-overflow-scrolling:touch;}[data-radix-select-viewport]::-webkit-scrollbar{display:none}"},nonce:z}),v.jsx(QV.Slot,{scope:q,children:v.jsx(wA.div,{"data-radix-select-viewport":"",role:"presentation",...Y,ref:U,style:{position:"relative",flex:1,overflow:"hidden auto",...Y.style},onScroll:LA(Y.onScroll,(W)=>{let J=W.currentTarget,{contentWrapper:I,shouldExpandOnScrollRef:K}=Q;if(K?.current&&I){let N=Math.abs(B.current-J.scrollTop);if(N>0){let O=window.innerHeight-I7*2,j=parseFloat(I.style.minHeight),T=parseFloat(I.style.height),G=Math.max(j,T);if(G<O){let D=G+N,X=Math.min(O,D),H=D-X;if(I.style.height=X+"px",I.style.bottom==="0px")J.scrollTop=H>0?H:0,I.style.justifyContent="flex-end"}}}B.current=J.scrollTop})})})]})},"SelectViewport")),iX="SelectGroup",[i4,rX]=Tq(iX);var sX="SelectLabel",B1=C.forwardRef(AA(function(M,Z){let{__scopeSelect:q,...z}=M,Y=rX(sX,q);return v.jsx(wA.div,{id:Y.id,...z,ref:Z})},"SelectLabel")),q1="SelectItem",[oX,jT]=Tq(q1),G1=C.forwardRef(AA(function(M,Z){let{__scopeSelect:q,value:z,disabled:Y=!1,textValue:V,...Q}=M,U=SZ(q1,q),B=Kq(q1,q),W=U.value===z,[J,I]=C.useState(V??""),[K,N]=C.useState(!1),O=EM((X)=>B.itemRefCallback?.(X,z,Y)),j=IA(Z,O),T=v3(),G=C.useRef("touch"),D=AA(()=>{if(!Y)U.onValueChange(z),U.onOpenChange(!1)},"handleSelect");return v.jsx(oX,{scope:q,value:z,disabled:Y,textId:T,isSelected:W,onItemTextChange:C.useCallback((X)=>{I((H)=>H||(X?.textContent??"").trim())},[]),children:v.jsx(QV.ItemSlot,{scope:q,value:z,disabled:Y,textValue:J,children:v.jsx(wA.div,{role:"option","aria-labelledby":T,"data-highlighted":K?"":void 0,"aria-selected":W&&K,"data-state":W?"checked":"unchecked","aria-disabled":Y||void 0,"data-disabled":Y?"":void 0,tabIndex:Y?void 0:-1,...Q,ref:j,onFocus:LA(Q.onFocus,()=>N(!0)),onBlur:LA(Q.onBlur,()=>N(!1)),onClick:LA(Q.onClick,()=>{if(G.current!=="mouse")D()}),onPointerUp:LA(Q.onPointerUp,()=>{if(G.current==="mouse")D()}),onPointerDown:LA(Q.onPointerDown,(X)=>{G.current=X.pointerType}),onPointerMove:LA(Q.onPointerMove,(X)=>{if(G.current=X.pointerType,Y)B.onItemLeave?.();else if(G.current==="mouse")X.currentTarget.focus({preventScroll:!0})}),onPointerLeave:LA(Q.onPointerLeave,(X)=>{if(X.currentTarget===document.activeElement)B.onItemLeave?.()}),onKeyDown:LA(Q.onKeyDown,(X)=>{if(Y||X.target!==X.currentTarget)return;if(B.searchRef?.current!==""&&X.key===" ")return;if(bX.includes(X.key))D();if(X.key===" ")X.preventDefault()})})})})},"SelectItem")),VV="SelectItemText",XT=C.forwardRef(AA(function(M,Z){let{__scopeSelect:q,className:z,style:Y,...V}=M,Q=SZ(VV,q),U=Kq(VV,q),B=jT(VV,q),W=yX(VV,q),[J,I]=C.useState(null),K=EM((D)=>U.itemTextRefCallback?.(D,B.value,B.disabled)),N=IA(Z,I,B.onItemTextChange,K),O=J?.textContent,j=C.useMemo(()=>v.jsx("option",{value:B.value,disabled:B.disabled,children:O},B.value),[B.disabled,B.value,O]),{onNativeOptionAdd:T,onNativeOptionRemove:G}=W;return KA(()=>{return T(j),()=>G(j)},[T,G,j]),v.jsxs(v.Fragment,{children:[v.jsx(wA.span,{id:B.textId,...V,ref:N}),B.isSelected&&Q.valueNode&&!Q.valueNodeHasChildren&&!lY(Q.value)?z1.createPortal(V.children,Q.valueNode):null]})},"SelectItemText")),aX="SelectItemIndicator",OT=C.forwardRef(AA(function(M,Z){let{__scopeSelect:q,...z}=M;return jT(aX,q).isSelected?v.jsx(wA.span,{"aria-hidden":!0,...z,ref:Z}):null},"SelectItemIndicator")),BT="SelectScrollUpButton",I1=C.forwardRef(AA(function(M,Z){let q=Kq(BT,M.__scopeSelect),z=U1(BT,M.__scopeSelect),[Y,V]=C.useState(!1),Q=IA(Z,z.onScrollButtonChange);return KA(()=>{if(q.viewport&&q.isPositioned){let B=function(){let J=W.scrollTop>0;V(J)};var U=B;AA(B,"handleScroll");let W=q.viewport;return B(),W.addEventListener("scroll",B),()=>W.removeEventListener("scroll",B)}},[q.viewport,q.isPositioned]),Y?v.jsx(ET,{...M,ref:Q,onAutoScroll:()=>{let{viewport:U,selectedItem:B}=q;if(U&&B)U.scrollTop=U.scrollTop-B.offsetHeight}}):null},"SelectScrollUpButton")),GT="SelectScrollDownButton",W1=C.forwardRef(AA(function(M,Z){let q=Kq(GT,M.__scopeSelect),z=U1(GT,M.__scopeSelect),[Y,V]=C.useState(!1),Q=IA(Z,z.onScrollButtonChange);return KA(()=>{if(q.viewport&&q.isPositioned){let B=function(){let J=W.scrollHeight-W.clientHeight,I=Math.ceil(W.scrollTop)<J;V(I)};var U=B;AA(B,"handleScroll");let W=q.viewport;return B(),W.addEventListener("scroll",B),()=>W.removeEventListener("scroll",B)}},[q.viewport,q.isPositioned]),Y?v.jsx(ET,{...M,ref:Q,onAutoScroll:()=>{let{viewport:U,selectedItem:B}=q;if(U&&B)U.scrollTop=U.scrollTop+B.offsetHeight}}):null},"SelectScrollDownButton")),ET=C.forwardRef(AA(function(M,Z){let{__scopeSelect:q,onAutoScroll:z,...Y}=M,V=Kq("SelectScrollButton",q),Q=C.useRef(null),U=UV(q),B=C.useCallback(()=>{if(Q.current!==null)window.clearInterval(Q.current),Q.current=null},[]);return C.useEffect(()=>{return()=>B()},[B]),KA(()=>{U().find((J)=>J.ref.current===document.activeElement)?.ref.current?.scrollIntoView({block:"nearest"})},[U]),v.jsx(wA.div,{"aria-hidden":!0,...Y,ref:Z,style:{flexShrink:0,...Y.style},onPointerDown:LA(Y.onPointerDown,()=>{if(Q.current===null)Q.current=window.setInterval(z,50)}),onPointerMove:LA(Y.onPointerMove,()=>{if(V.onItemLeave?.(),Q.current===null)Q.current=window.setInterval(z,50)}),onPointerLeave:LA(Y.onPointerLeave,()=>{B()})})},"SelectScrollButtonImpl")),J1=C.forwardRef(AA(function(M,Z){let{__scopeSelect:q,...z}=M;return v.jsx(wA.div,{"aria-hidden":!0,...z,ref:Z})},"SelectSeparator"));var nX="SelectBubbleInput",$X=C.forwardRef(AA(function({__scopeSelect:M,...Z},q){let z=SZ(nX,M),{value:Y,onValueChange:V,required:Q,disabled:U,name:B,autoComplete:W,form:J}=z,{nativeOptions:I,nativeSelectKey:K}=z,N=C.useRef(null),O=IA(q,N),j=Y??"",T=pU(j),G=Array.from(I).some((D)=>(D.props.value??"")==="");return C.useEffect(()=>{let D=N.current;if(!D)return;let X=window.HTMLSelectElement.prototype,L=Object.getOwnPropertyDescriptor(X,"value").set;if(T!==j&&L){let F=new Event("change",{bubbles:!0});L.call(D,j),D.dispatchEvent(F)}},[T,j]),v.jsxs(wA.select,{"aria-hidden":!0,required:Q,tabIndex:-1,name:B,autoComplete:W,disabled:U,form:J,onChange:(D)=>V(D.target.value),...Z,style:{...mJ,...Z.style},ref:O,defaultValue:j,children:[lY(Y)&&!G?v.jsx("option",{value:""}):null,Array.from(I)]},K)},"SelectBubbleInput"));function RT(A){return typeof A==="function"}AA(RT,"isFunction");function lY(A){return A===""||A===void 0}AA(lY,"shouldShowPlaceholder");function T1(A){let M=EM(A),Z=C.useRef(""),q=C.useRef(0),z=C.useCallback((V)=>{let Q=Z.current+V;M(Q),AA(function U(B){if(Z.current=B,window.clearTimeout(q.current),B!=="")q.current=window.setTimeout(()=>U(""),1000)},"updateSearch")(Q)},[M]),Y=C.useCallback(()=>{Z.current="",window.clearTimeout(q.current)},[]);return C.useEffect(()=>{return()=>window.clearTimeout(q.current)},[]),[Z,z,Y]}AA(T1,"useTypeaheadSearch");function K1(A,M,Z){let z=M.length>1&&Array.from(M).every((B)=>B===M[0])?M[0]:M,Y=Z?A.indexOf(Z):-1,V=HT(A,Math.max(Y,0));if(z.length===1)V=V.filter((B)=>B!==Z);let U=V.find((B)=>B.textValue.toLowerCase().startsWith(z.toLowerCase()));return U!==Z?U:void 0}AA(K1,"findNextItem");function HT(A,M){return A.map((Z,q)=>A[(M+q)%A.length])}AA(HT,"wrapArray");var GV=y(l(),1);var BV=(...A)=>A.filter((M,Z,q)=>{return Boolean(M)&&M.trim()!==""&&q.indexOf(M)===Z}).join(" ").trim();var FT=(A)=>A.replace(/([a-z0-9])([A-Z])/g,"$1-$2").toLowerCase();var LT=(A)=>A.replace(/^([A-Z])|[\s-_]+(\w)/g,(M,Z,q)=>q?q.toUpperCase():Z.toLowerCase());var D1=(A)=>{let M=LT(A);return M.charAt(0).toUpperCase()+M.slice(1)};var iY=y(l(),1);var wT={xmlns:"http://www.w3.org/2000/svg",width:24,height:24,viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:2,strokeLinecap:"round",strokeLinejoin:"round"};var kT=(A)=>{for(let M in A)if(M.startsWith("aria-")||M==="role"||M==="title")return!0;return!1};var CT=iY.forwardRef(({color:A="currentColor",size:M=24,strokeWidth:Z=2,absoluteStrokeWidth:q,className:z="",children:Y,iconNode:V,...Q},U)=>iY.createElement("svg",{ref:U,...wT,width:M,height:M,stroke:A,strokeWidth:q?Number(Z)*24/Number(M):Z,className:BV("lucide",z),...!Y&&!kT(Q)&&{"aria-hidden":"true"},...Q},[...V.map(([B,W])=>iY.createElement(B,W)),...Array.isArray(Y)?Y:[Y]]));var HM=(A,M)=>{let Z=GV.forwardRef(({className:q,...z},Y)=>GV.createElement(CT,{ref:Y,iconNode:M,className:BV(`lucide-${FT(D1(A))}`,`lucide-${A}`,q),...z}));return Z.displayName=D1(A),Z};var tX=[["path",{d:"M20 6 9 17l-5-5",key:"1gmf2c"}]],Fz=HM("check",tX);var eX=[["path",{d:"m6 9 6 6 6-6",key:"qrunsl"}]],Lz=HM("chevron-down",eX);var AO=[["path",{d:"m18 15-6-6-6 6",key:"153udz"}]],rY=HM("chevron-up",AO);var MO=[["path",{d:"M4 12.15V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2h-3.35",key:"1wthlu"}],["path",{d:"M14 2v5a1 1 0 0 0 1 1h5",key:"wfsgrz"}],["path",{d:"m5 16-3 3 3 3",key:"331omg"}],["path",{d:"m9 22 3-3-3-3",key:"lsp7cz"}]],PZ=HM("file-code-corner",MO);var ZO=[["path",{d:"M2.586 17.414A2 2 0 0 0 2 18.828V21a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h1a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h.172a2 2 0 0 0 1.414-.586l.814-.814a6.5 6.5 0 1 0-4-4z",key:"1s6t7t"}],["path",{d:"",key:"w0ekpg"}]],sY=HM("key-round",ZO);var qO=[["rect",{width:"7",height:"9",x:"3",y:"3",rx:"1",key:"10lvy0"}],["rect",{width:"7",height:"5",x:"14",y:"3",rx:"1",key:"16une8"}],["rect",{width:"7",height:"9",x:"14",y:"12",rx:"1",key:"1hutg5"}],["rect",{width:"7",height:"5",x:"3",y:"16",rx:"1",key:"ldoo1y"}]],oY=HM("layout-dashboard",qO);var zO=[["path",{d:"M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z",key:"oel41y"}]],aY=HM("shield",zO);var xA=y(uA(),1),bT=WT;var ST=JT,N1=xZ.forwardRef(({className:A,children:M,...Z},q)=>xA.jsxs(V1,{ref:q,className:z7("flex h-9 w-full items-center justify-between whitespace-nowrap rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm ring-offset-background cursor-pointer data-[placeholder]:text-muted-foreground focus:outline-none focus:ring-1 focus:ring-ring disabled:cursor-not-allowed disabled:opacity-50 [&>span]:line-clamp-1",A),...Z,children:[M,xA.jsx(TT,{asChild:!0,children:xA.jsx(Lz,{className:"h-4 w-4 opacity-50"})})]}));N1.displayName=V1.displayName;var PT=xZ.forwardRef(({className:A,...M},Z)=>xA.jsx(I1,{ref:Z,className:z7("flex cursor-default items-center justify-center py-1",A),...M,children:xA.jsx(rY,{className:"h-4 w-4"})}));PT.displayName=I1.displayName;var xT=xZ.forwardRef(({className:A,...M},Z)=>xA.jsx(W1,{ref:Z,className:z7("flex cursor-default items-center justify-center py-1",A),...M,children:xA.jsx(Lz,{className:"h-4 w-4"})}));xT.displayName=W1.displayName;var j1=xZ.forwardRef(({className:A,children:M,position:Z="popper",...q},z)=>xA.jsx(KT,{children:xA.jsxs(Q1,{ref:z,className:z7("relative z-50 max-h-(--radix-select-content-available-height) min-w-[8rem] overflow-y-auto overflow-x-hidden rounded-md border bg-popover text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 origin-(--radix-select-content-transform-origin)",Z==="popper"&&"data-[side=bottom]:translate-y-1 data-[side=left]:-translate-x-1 data-[side=right]:translate-x-1 data-[side=top]:-translate-y-1",A),position:Z,...q,children:[xA.jsx(PT,{}),xA.jsx(NT,{className:z7("p-1",Z==="popper"&&"h-[var(--radix-select-trigger-height)] w-full min-w-[var(--radix-select-trigger-width)]"),children:M}),xA.jsx(xT,{})]})}));j1.displayName=Q1.displayName;var YO=xZ.forwardRef(({className:A,...M},Z)=>xA.jsx(B1,{ref:Z,className:z7("px-2 py-1.5 text-sm font-semibold",A),...M}));YO.displayName=B1.displayName;var X1=xZ.forwardRef(({className:A,children:M,...Z},q)=>xA.jsxs(G1,{ref:q,className:z7("relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-2 pr-8 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",A),...Z,children:[xA.jsx("span",{className:"absolute right-2 flex h-3.5 w-3.5 items-center justify-center",children:xA.jsx(OT,{children:xA.jsx(Fz,{className:"h-4 w-4"})})}),xA.jsx(XT,{children:M})]}));X1.displayName=G1.displayName;var VO=xZ.forwardRef(({className:A,...M},Z)=>xA.jsx(J1,{ref:Z,className:z7("-mx-1 my-1 h-px bg-muted",A),...M}));VO.displayName=J1.displayName;var O1={url:"data:image/png;base64,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"};var E=y(uA(),1);function yT({value:A,onChange:M,children:Z,...q}){let z=n.default.Children.toArray(Z).flatMap((Y)=>Array.isArray(Y)?Y:[Y]);return E.jsxs(bT,{value:A||"__empty",onValueChange:(Y)=>M({target:{value:Y==="__empty"?"":Y}}),children:[E.jsx(N1,{...q,children:E.jsx(ST,{})}),E.jsx(j1,{side:"bottom",align:"start",avoidCollisions:!1,sideOffset:6,className:"v-dropdown",children:z.map((Y)=>n.default.isValidElement(Y)?E.jsx(X1,{value:Y.props.value||"__empty",children:Y.props.children},Y.props.value||"__empty"):null)})]})}function UO(A=24){let M=["abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ","0123456789","#₺+;*@$!%&?-_=."],Z=(Y)=>{let V=new Uint32Array(1),Q=Math.floor(4294967296/Y)*Y;do crypto.getRandomValues(V);while(V[0]>=Q);return V[0]%Y},q=M.map((Y)=>Y[Z(Y.length)]),z=M.join("");while(q.length<A)q.push(z[Z(z.length)]);for(let Y=q.length-1;Y>0;Y--){let V=Z(Y+1);[q[Y],q[V]]=[q[V],q[Y]]}return q.join("")}var W7={scripts:"v26.scripts",keys:"v26.keys",activity:"v26.activity"},wz=(A,M)=>{try{let Z=localStorage.getItem(A);return Z?JSON.parse(Z):M}catch{return M}},Dq=(A,M)=>localStorage.setItem(A,JSON.stringify(M)),kz=(A=10)=>{let Z="";for(let q=0;q<A;q++)Z+="ABCDEFGHJKMNPQRSTUVWXYZ23456789"[Math.floor(Math.random()*31)];return Z},WV=(A)=>new Date(A).toLocaleString("en-GB");async function BO(A){if(window.crypto?.subtle){let Z=await crypto.subtle.digest("SHA-256",new TextEncoder().encode(A));return Array.from(new Uint8Array(Z)).map((q)=>q.toString(16).padStart(2,"0")).join("")}let M=2166136261;for(let Z=0;Z<A.length;Z++)M^=A.charCodeAt(Z),M=M*16777619>>>0;return(M.toString(16)+Math.random().toString(16).slice(2)).padEnd(64,"0").slice(0,64)}var GO=(A)=>btoa(unescape(encodeURIComponent(A))),IO=(A,M)=>{while(A.length%3)A+=" ";let Z="";for(let q=0;q<A.length;q++)Z+=String.fromCharCode(A.charCodeAt(q)^M.charCodeAt(q%M.length));return Z},hT=(A)=>{let M='"';for(let Z=0;Z<A.length;Z++)M+="\\"+A.charCodeAt(Z);return M+'"'},WO=(A)=>{let M=[];for(let Z=0;Z<A;Z++)M.push(`local _${kz(5).toLowerCase()}=${Math.floor(Math.random()*1e9)}`);return M.join(";")};// These self-contained functions are also embedded in the standalone HTML.
function v26Loader(hash, hostedUrl) {
  if (!/^[a-f0-9]{32,64}$/i.test(hash)) throw new Error("Invalid script hash.");
  const fallback = `https://projectv26.space/scripts/hosted/${hash}.lua`;
  let url = fallback;
  if (hostedUrl) {
    const candidate = new URL(hostedUrl, "https://projectv26.space");
    if (candidate.origin !== "https://projectv26.space" || !candidate.pathname.startsWith("/scripts/hosted/") || !candidate.pathname.endsWith(".lua") || candidate.search || candidate.hash) {
      throw new Error("Hosting did not return a raw Lua URL.");
    }
    url = candidate.href;
  }
  return `script_key = "YOUR_KEY_HERE"\n\nloadstring(game:HttpGet(${JSON.stringify(url)}))()`;
}

function v26Protect(source, layers = 3) {
  const bytes = (text) => new TextEncoder().encode(text);
  const quote = (text) => '"' + Array.from(bytes(text), (byte) => "\\" + String(byte).padStart(3, "0")).join("") + '"';
  let code = 'local script_key = ...; if type(script_key) ~= "string" or script_key == "" or script_key == "YOUR_KEY_HERE" then error("[V2.6] missing script_key") end;\n' + source;
  for (let layer = 0; layer < Math.max(1, layers); layer++) {
    const key = Array.from(crypto.getRandomValues(new Uint8Array(16)), (b) => String.fromCharCode(65 + b % 26)).join("");
    const input = bytes(code);
    const encrypted = Array.from(input, (byte, index) => String.fromCharCode(byte ^ key.charCodeAt(index % key.length))).join("");
    const encoded = btoa(encrypted);
    code = `local script_key = ...;
local function _decode(s, k)
  local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  local out = {}
  for i = 1, #s, 4 do
    local a = string.find(alphabet, s:sub(i,i), 1, true) - 1
    local b = string.find(alphabet, s:sub(i+1,i+1), 1, true) - 1
    local c3, c4 = s:sub(i+2,i+2), s:sub(i+3,i+3)
    local c = c3 == "=" and 0 or string.find(alphabet, c3, 1, true) - 1
    local d = c4 == "=" and 0 or string.find(alphabet, c4, 1, true) - 1
    local value = a * 262144 + b * 4096 + c * 64 + d
    out[#out+1] = string.char(math.floor(value / 65536) % 256)
    if c3 ~= "=" then out[#out+1] = string.char(math.floor(value / 256) % 256) end
    if c4 ~= "=" then out[#out+1] = string.char(value % 256) end
  end
  local decoded = table.concat(out)
  local result = {}
  for i = 1, #decoded do
    result[i] = string.char(bit32.bxor(decoded:byte(i), k:byte((i-1) % #k + 1)))
  end
  return table.concat(result)
end
if type(loadstring) ~= "function" then error("[V2.6] loadstring is unavailable") end
local fn, err = loadstring(_decode(${quote(encoded)}, ${quote(key)}))
if not fn then error("[V2.6] bad payload: " .. tostring(err)) end
return fn(script_key)`;
  }
  return `-- PROJECT V2.6 PROTECTED BUILD\nreturn (function(...)\n${code}\nend)(script_key or (getgenv and getgenv().script_key) or (getfenv and getfenv(0).script_key) or _G.script_key)`;
}
function JO(A,M=3){return v26Protect(A,M)}var TO=v26Loader;function vT({size:A=34}){return E.jsxs("div",{className:"flex items-center gap-3",children:[E.jsx("img",{className:"v-brand-logo",src:O1.url,alt:"PROJECT V2.6"}),E.jsx("div",{className:"flex items-center gap-2.5",children:E.jsx("span",{className:"v-brand-name",children:"PROJECT V2.6"})})]})}function yZ({label:A,children:M}){return E.jsxs("label",{className:"grid gap-1.5",children:[E.jsx("span",{className:"text-[11px] uppercase tracking-wider text-muted-foreground",children:A}),M]})}function IV({k:A,v:M,d:Z}){return E.jsxs("div",{className:"rounded-xl border border-border bg-card p-4",children:[E.jsx("div",{className:"text-[11px] uppercase tracking-wider text-muted-foreground",children:A}),E.jsx("div",{className:"mt-1 font-mono text-2xl font-bold text-foreground",children:M}),Z&&E.jsx("div",{className:"mt-1 text-[11px] text-muted-foreground",children:Z})]})}function Cz({title:A,hint:M,children:Z}){return E.jsxs("section",{className:"mt-4 rounded-xl border border-border bg-card p-5",children:[E.jsx("h3",{className:"text-sm font-semibold tracking-wide text-foreground",children:A}),M&&E.jsx("p",{className:"mt-1 text-xs text-muted-foreground",children:M}),E.jsx("div",{className:"mt-4",children:Z})]})}
function vDownloadIcon(){return E.jsxs("svg",{width:24,height:24,viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:1.5,"aria-hidden":true,children:[E.jsx("path",{d:"M12 3v12m-5-5 5 5 5-5M4 16v4h16v-4"})]});}
function vDiscordIcon(){return E.jsx("svg",{width:20,height:20,viewBox:"0 0 24 24",fill:"currentColor","aria-hidden":true,children:E.jsx("path",{d:"M20.317 4.37a19.791 19.791 0 0 0-4.885-1.515c-.211.375-.454.88-.621 1.28a18.27 18.27 0 0 0-5.416 0 12.64 12.64 0 0 0-.63-1.28A19.736 19.736 0 0 0 3.88 4.37C.792 8.956-.045 13.428.374 17.836a19.9 19.9 0 0 0 5.993 3.03c.485-.66.917-1.36 1.29-2.095a12.9 12.9 0 0 1-2.032-.986c.17-.125.337-.255.498-.389 3.92 1.817 8.18 1.817 12.054 0 .163.134.33.264.499.389a13.13 13.13 0 0 1-2.036.988c.374.733.805 1.433 1.29 2.093a19.86 19.86 0 0 0 6.002-3.03c.49-5.11-.838-9.54-3.615-13.466ZM8.02 15.139c-1.182 0-2.153-1.085-2.153-2.419 0-1.333.95-2.42 2.153-2.42 1.202 0 2.173 1.087 2.153 2.42 0 1.334-.951 2.419-2.153 2.419Zm7.96 0c-1.183 0-2.154-1.085-2.154-2.419 0-1.333.951-2.42 2.154-2.42 1.202 0 2.173 1.087 2.153 2.42 0 1.334-.951 2.419-2.153 2.419Z"})})}
function vDiscordLogin(){return E.jsxs(oA,{variant:"discord",className:"v-discord-login",onClick:()=>{window.top.location.assign("/auth/discord/login")},children:[vDiscordIcon(),"Log-in with Discord"]})}
function KO(){return E.jsxs("div",{className:"v-auth",children:[E.jsxs("div",{className:"v-auth-tl v-rise",style:{"--d":"0s"},children:[E.jsx("img",{src:O1.url,alt:""}),E.jsx("span",{children:"PROJECT V2.6"}),E.jsx("i",{})]}),E.jsxs("div",{className:"v-auth-tr v-rise",style:{"--d":".1s"},children:["Your space.",E.jsx("br",{}),"Your work.",E.jsx("br",{}),"Your rules."]}),E.jsxs("div",{className:"v-auth-bl v-rise",style:{"--d":".2s"},children:["Secure",E.jsx("br",{}),"Workspace"]}),E.jsxs("div",{className:"v-auth-br v-rise",style:{"--d":".2s"},children:["V2.6",E.jsx("i",{})]}),E.jsxs("div",{className:"v-auth-card v-rise",style:{"--d":".15s"},children:[E.jsxs("div",{className:"v-auth-brand",children:[E.jsx("img",{src:O1.url,alt:"PROJECT V2.6"}),E.jsxs("div",{children:[E.jsx("b",{children:"PROJECT"})," V2.6"]})]}),E.jsx("h1",{children:"Sign in"}),E.jsx("p",{className:"v-auth-sub",children:"Private access to your secure workspace."}),E.jsx(vDiscordLogin,{})]})]})}
function vSvg(p,k){return E.jsx("svg",{width:18,height:18,viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:1.6,strokeLinecap:"round",strokeLinejoin:"round","aria-hidden":true,children:p.map((d,i)=>E.jsx("path",{d},i))},k)}
function vIcArrow(){return vSvg(["M5 12h14","m13 6 6 6-6 6"])}
function vIcNE(){return vSvg(["M7 17 17 7","M8 7h9v9"])}
async function vCopy(t){try{if(navigator.clipboard&&window.isSecureContext){await navigator.clipboard.writeText(t);return true}}catch{}try{let a=document.createElement("textarea");a.value=t;a.setAttribute("readonly","");a.style.cssText="position:fixed;top:0;left:0;opacity:0;pointer-events:none";document.body.appendChild(a);a.focus();a.select();a.setSelectionRange(0,t.length);let ok=document.execCommand("copy");a.remove();return ok}catch{return false}}
async function vApi(b){try{const r=await fetch("https://projectv26.space/api/key",{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify(b)});const d=await r.json().catch(()=>({}));return r.ok&&d.ok}catch(e){return false}}function vOwn(list,id){const s=list.find(x=>x.id===id);return s?{hash:s.hash,owner:s.owner}:{}}function vLeft(ms){if(ms<=0)return"0s";let s=Math.floor(ms/1000),d=Math.floor(s/86400),h=Math.floor(s%86400/3600),m=Math.floor(s%3600/60),x=s%60;return d?`${d}d ${h}h ${m}m`:h?`${h}h ${m}m ${x}s`:m?`${m}m ${x}s`:`${x}s`}
function vHwidUnit(ms){return ms>=86400000?"d":ms>=3600000?"h":"m"}
function vHwidReset(k,scripts,setKeys,keys,log,show){let now=Date.now(),cd=k.hwidCooldown||0,last=k.hwidResetAt||0;if(k.revoked)return show("Key is revoked.");if(cd&&last&&now-last<cd)return show("HWID reset available in "+vLeft(cd-(now-last))+".");vApi({action:"reset_hwid",...vOwn(scripts,k.scriptId),key:k.key}).then(ok=>{if(!ok)show("Server could not reset HWID.")});setKeys(keys.map(x=>x.id===k.id?{...x,hwidResetAt:now}:x));log("key.hwid_reset",k.key);show("HWID reset.")}
function vHwidPanel({keys:A,scripts:M,setKeys:S,log:L,show:Q}){let[k,setK]=n.useState("");let go=()=>{let v=k.trim();if(!v)return Q("Enter a key.");let f=A.find(x=>x.key===v);if(!f)return Q("Key not found.");vHwidReset(f,M,S,A,L,Q);setK("")};return E.jsx(Cz,{title:"HWID Reset",hint:"Unlink a key from its device. Respects the key's reset cooldown.",children:E.jsxs("div",{className:"flex gap-3 max-md:flex-col",children:[E.jsx("input",{className:"v-input font-mono",value:k,onChange:e=>setK(e.target.value),onKeyDown:e=>{if(e.key==="Enter")go()},placeholder:"paste a key"}),E.jsx(oA,{className:"v-btn-primary",onClick:go,children:"Reset HWID"})]})})}
function vKeyCheck({keys:A,scripts:M}){let[k,setK]=n.useState(""),[r,setR]=n.useState(null);let check=()=>{let v=k.trim();if(!v)return setR({ok:false,t:"Enter a key."});let f=A.find(x=>x.key===v);if(!f)return setR({ok:false,t:"Invalid key — not found, expired or deleted."});if(f.expiresAt&&f.expiresAt<=Date.now())return setR({ok:false,t:"Key expired."});if(f.revoked)return setR({ok:false,t:"Key revoked."});let s=M.find(x=>x.id===f.scriptId);if(!s)return setR({ok:false,t:"Script no longer exists."});if(s.killed)return setR({ok:false,t:"Script disabled — key blocked."});setR({ok:true,t:`Valid · ${s.name} · `+(f.expiresAt?vLeft(f.expiresAt-Date.now())+" left":"never expires")})};return E.jsx(Cz,{title:"Check Key",hint:"Expired keys are deleted automatically and stop working.",children:E.jsxs("div",{className:"flex gap-3 max-md:flex-col",children:[E.jsx("input",{className:"v-input font-mono",value:k,onChange:e=>{setK(e.target.value);setR(null)},onKeyDown:e=>{if(e.key==="Enter")check()},placeholder:"paste a key"}),E.jsx(oA,{className:"v-btn-primary",onClick:check,children:"Check"}),r&&E.jsx("span",{className:`self-center text-xs ${r.ok?"text-success":"text-destructive"}`,children:r.t})]})})}
function vLanding({onGo:A}){return E.jsxs("div",{className:"v-landing",children:[E.jsx("div",{className:"v-landing-bg"}),E.jsxs("header",{className:"v-landing-top v-rise",style:{"--d":".1s"},children:[E.jsx("img",{src:O1.url,alt:""}),E.jsx("i",{}),E.jsx("span",{children:"PROJECT V2.6"})]}),E.jsxs("main",{className:"v-landing-main",children:[E.jsxs("div",{className:"v-landing-copy",children:[E.jsxs("p",{className:"v-landing-eyebrow v-rise",style:{"--d":".3s"},children:["Protecting your code with our best work.",E.jsx("br",{}),"Completely free!"]}),E.jsxs("h1",{className:"v-rise",style:{"--d":".45s"},children:["Your code.",E.jsx("br",{}),"Your control."]}),E.jsx("p",{className:"v-landing-sub v-rise",style:{"--d":".6s"},children:"High quality scripts, constant updates and a modern workspace for your Roblox journey."}),E.jsxs("div",{className:"v-landing-cta v-rise",style:{"--d":".75s"},children:[E.jsxs("button",{className:"v-landing-primary",onClick:A,children:["Join V2.6",vIcArrow()]}),E.jsxs("button",{className:"v-landing-ghost",onClick:A,children:[vIcNE(),"Contact Staff"]})]})]}),E.jsx("img",{src:O1.url,alt:"PROJECT V2.6",className:"v-landing-logo"})]})]})}
function DO({scripts:A,keys:M,activity:Z}){let q=M.filter((Y)=>!Y.revoked&&(!Y.expiresAt||Y.expiresAt>Date.now())).length,z=Z[0]?.t?WV(Z[0].t):"—";return E.jsxs(E.Fragment,{children:[E.jsxs("div",{className:"grid grid-cols-4 gap-3 max-md:grid-cols-2",children:[E.jsx(IV,{k:"Protected",v:A.length,d:"scripts"}),E.jsx(IV,{k:"Active keys",v:q,d:"ready to use"}),E.jsx(IV,{k:"Disabled",v:A.filter((Y)=>Y.killed).length,d:"scripts"}),E.jsx(IV,{k:"Updated",v:z,d:"local time"})]}),E.jsx(Cz,{title:"Activity",children:E.jsx("div",{className:"overflow-x-auto",children:E.jsxs("table",{className:"w-full text-sm",children:[E.jsx("thead",{children:E.jsxs("tr",{className:"text-[11px] uppercase tracking-wider text-muted-foreground",children:[E.jsx("th",{className:"py-2 text-left font-semibold",children:"Time"}),E.jsx("th",{className:"py-2 text-left font-semibold",children:"Event"}),E.jsx("th",{className:"py-2 text-left font-semibold",children:"Detail"})]})}),E.jsxs("tbody",{children:[Z.length===0&&E.jsx("tr",{children:E.jsx("td",{colSpan:3,className:"py-3 text-muted-foreground",children:"No activity yet."})}),Z.map((Y,V)=>E.jsxs("tr",{className:"border-t border-border",children:[E.jsx("td",{className:"py-2 font-mono text-xs text-muted-foreground",children:WV(Y.t)}),E.jsx("td",{className:"py-2 text-foreground",children:Y.event}),E.jsx("td",{className:"py-2 text-muted-foreground",children:Y.detail})]},V))]})]})})})]})}
function vStorageMessage(err){return err&&(err.name==="QuotaExceededError"||err.name==="NS_ERROR_DOM_QUOTA_REACHED")?"Not enough browser storage for this protected script. Delete unused scripts or choose a smaller file, then try again. Your existing scripts are unchanged.":err&&err.name==="SecurityError"?"Browser storage is unavailable. Allow storage for this page and try again.":"Protection failed. "+(err&&err.message?err.message:"Please try again.")}
function vSafePersist(key,value){try{Dq(key,value);return true}catch(err){window.dispatchEvent(new CustomEvent("v26-storage-error",{detail:vStorageMessage(err)}));return false}}
function vOpenScriptDb(){return new Promise((resolve,reject)=>{if(!window.indexedDB)return reject(new Error("Large browser storage is unavailable in this browser."));let request=indexedDB.open("project-v26-storage",1);request.onupgradeneeded=()=>{let db=request.result;if(!db.objectStoreNames.contains("protected-scripts"))db.createObjectStore("protected-scripts",{keyPath:"id"})};request.onsuccess=()=>resolve(request.result);request.onerror=()=>reject(request.error||new Error("Could not open large browser storage."))})}
async function vStoreProtectedScript(row){let db=await vOpenScriptDb();try{await new Promise((resolve,reject)=>{let tx=db.transaction("protected-scripts","readwrite");tx.objectStore("protected-scripts").put(row);tx.oncomplete=resolve;tx.onerror=()=>reject(tx.error||new Error("Could not save protected script."));tx.onabort=()=>reject(tx.error||new Error("Could not save protected script."))})}finally{db.close()}}
async function vDeleteProtectedScript(id){let db=await vOpenScriptDb();try{await new Promise((resolve,reject)=>{let tx=db.transaction("protected-scripts","readwrite");tx.objectStore("protected-scripts").delete(id);tx.oncomplete=resolve;tx.onerror=()=>reject(tx.error||new Error("Could not delete protected script."));tx.onabort=()=>reject(tx.error||new Error("Could not delete protected script."))})}finally{db.close()}}
async function vPrepareLargeStorage(rows){try{if(navigator.storage?.persist)await navigator.storage.persist();let legacy=rows.filter(row=>typeof row.obf==="string");for(let row of legacy)await vStoreProtectedScript(row);if(legacy.length)Dq(W7.scripts,rows.map(({obf,...meta})=>meta))}catch(err){window.dispatchEvent(new CustomEvent("v26-storage-error",{detail:vStorageMessage(err)}))}}
function vProtectAsync(source){return new Promise((resolve,reject)=>{if(typeof Worker==="undefined"){setTimeout(()=>{try{resolve(v26Protect(source,2))}catch(err){reject(err)}},50);return}let worker,url,timer;let cleanup=()=>{clearTimeout(timer);worker?.terminate();if(url)URL.revokeObjectURL(url)};try{let code=v26Protect.toString()+";onmessage=e=>{try{postMessage({value:v26Protect(e.data,2)})}catch(err){postMessage({error:err.message})}}";
url=URL.createObjectURL(new Blob([code],{type:"text/javascript"}));worker=new Worker(url);timer=setTimeout(()=>{cleanup();reject(new Error("This file took too long to protect. Try a smaller file."))},60000);worker.onmessage=e=>{cleanup();if(e.data.error)reject(new Error(e.data.error));else resolve(e.data.value)};worker.onerror=e=>{e.preventDefault();cleanup();reject(new Error("Could not start script protection."))};worker.postMessage(source)}catch(err){cleanup();reject(err)}})}
function NO({scripts:A,setScripts:M,log:Z,show:q}){
let [name,setName]=n.useState(""),[source,setSource]=n.useState(""),[fileName,setFileName]=n.useState(""),[busy,setBusy]=n.useState(false),[selected,setSelected]=n.useState(""),[drag,setDrag]=n.useState(false),[buildError,setBuildError]=n.useState(""),input=n.useRef(null),readVersion=n.useRef(0);
let item=A.find(x=>x.id===selected)||A[0]||null,loader=item&&!item.killed&&item.hosted!==false?TO(item.hash,item.hostedUrl):"";
async function read(file){if(!file)return;setBuildError("");let version=++readVersion.current;setSource("");setFileName("");if(!/\.(lua|luau|txt)$/i.test(file.name))return q("Select a .lua, .luau or .txt file.");if(file.size>5*1024*1024)return q("Maximum file size is 5 MB.");try{let text=await file.text();if(version!==readVersion.current)return;if(!text.trim())return q("File is empty.");setSource(text);setFileName(file.name);if(!name)setName(file.name.replace(/\.[^.]+$/,""));}catch{q("File could not be read.")}}
async function build(){if(busy)return;if(A.length>=5){q("Maximum 5 scripts allowed (5/5).");return setBuildError("Maximum 5 scripts reached (5/5). Use Update Script or Kill to manage existing scripts.");}if(!source.trim())return setBuildError("Select a code file from your device first.");setBuildError("");setBusy(true);window.v26Build?.show("Building loader","Protecting your script...");let pendingId="";try{let id="s_"+kz(10);pendingId=id;let obf=await vProtectAsync(source),hash=(await BO(id+"::"+obf.length+"::"+Date.now())).slice(0,32),row={id,hash,name:name.trim()||"untitled",createdAt:Date.now(),size:new Blob([source]).size,killed:false,hosted:true};window.v26Build?.set("Publishing protected build","Uploading the protected payload...");const r=await fetch("https://projectv26.space/l/host",{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify({hash:hash,name:row.name,lua:obf})});if(!r.ok){const detail=await r.text();throw new Error("HTTP "+r.status+": "+detail.slice(0,300))}const data=await r.json();if(data?.owner)row.owner=data.owner;try{await fetch("/api/site/register",{method:"POST",headers:{"Content-Type":"application/json"},credentials:"same-origin",body:JSON.stringify({hash:row.hash,owner:row.owner,name:row.name})})}catch(_){}if(!data?.url)throw new Error("The server did not return a loader URL.");const candidate=new URL(data.url,"https://projectv26.space");if(!candidate.pathname.startsWith("/scripts/hosted/"))throw new Error("The server returned an invalid loader URL.");v26Loader(hash,candidate.href);row.hostedUrl=candidate.href;window.v26Build?.set("Saving loader","Finishing your protected script...");await vStoreProtectedScript({...row,obf});const hosted=[{...row},...A];Dq(W7.scripts,hosted);M(hosted);setSelected(id);setSource("");setFileName("");Z("obfuscate",row.name+" ("+id+")");window.v26Build?.set("Loader ready","Your protected loader was created successfully.");q("Script hosted successfully.")}catch(err){if(pendingId){try{await vDeleteProtectedScript(pendingId)}catch{}}let message=vStorageMessage(err);setBuildError(message);q(message)}finally{setBusy(false);window.v26Build?.hide()}}
return E.jsxs(E.Fragment,{children:[E.jsx(Cz,{title:"Protect Script",children:E.jsxs("div",{className:"grid gap-3",children:[E.jsx(yZ,{label:"Script name",children:E.jsx("input",{className:"v-input",value:name,onChange:e=>setName(e.target.value),placeholder:"My script"})}),E.jsxs("div",{className:"v-drop-zone"+(drag?" is-dragging":""),onDragOver:e=>{e.preventDefault();setDrag(true)},onDragLeave:()=>setDrag(false),onDrop:e=>{e.preventDefault();setDrag(false);read(e.dataTransfer.files[0])},children:[E.jsx(vDownloadIcon,{}),E.jsx("h4",{children:"Drop your code here"}),E.jsx("span",{className:"v-file-name",children:fileName||".lua / .luau / .txt"}),E.jsx(oA,{variant:"outline",className:"v-btn-ghost v-file-button",onClick:()=>input.current?.click(),children:E.jsxs(E.Fragment,{children:[E.jsx(vDownloadIcon,{}),"Choose file"]})}),E.jsx("input",{ref:input,type:"file",accept:".lua,.luau,.txt",hidden:true,"aria-label":"Code file",onChange:e=>{read(e.target.files?.[0]);e.target.value=""}})]}),E.jsx(oA,{className:"v-btn-primary",disabled:busy||!source||A.length>=5,onClick:build,children:busy?"Protecting…":A.length>=5?"Script limit reached (5/5)":"Protect & build loader"}),buildError&&E.jsx("p",{role:"alert",className:"text-destructive text-sm",children:buildError})]})}),E.jsx(Cz,{title:`All Scripts (${A.length}/5)`,hint:"Manage up to 5 protected scripts.",children:E.jsx("div",{className:"overflow-x-auto",children:E.jsxs("table",{className:"w-full text-sm",children:[E.jsx("thead",{children:E.jsxs("tr",{className:"text-[11px] uppercase tracking-wider text-muted-foreground",children:[E.jsx("th",{className:"py-2 text-left font-semibold",children:"Script"}),E.jsx("th",{className:"py-2 text-left font-semibold",children:"Hash"}),E.jsx("th",{className:"py-2 text-left font-semibold",children:"Created"}),E.jsx("th",{className:"py-2 text-left font-semibold",children:"Status"}),E.jsx("th",{})]})}),E.jsxs("tbody",{children:[A.length===0&&E.jsx("tr",{children:E.jsx("td",{colSpan:5,className:"py-3 text-muted-foreground",children:"No scripts yet. Protect your first script above."})}),A.map((V)=>{let sldr="";try{sldr=TO(V.hash,V.hostedUrl)}catch(e){sldr=`script_key = "YOUR_KEY_HERE"\n\nloadstring(game:HttpGet("https://projectv26.space/scripts/hosted/${V.hash}.lua"))()`};return E.jsxs("tr",{className:"border-t border-border",children:[E.jsxs("td",{className:"py-2 text-foreground font-medium",children:[E.jsx("div",{children:V.name||"untitled"}),V.size?E.jsx("div",{className:"text-[10px] text-muted-foreground",children:V.size+" B"}):null]}),E.jsx("td",{className:"py-2 font-mono text-xs text-muted-foreground cursor-pointer",title:"Click to copy hash",onClick:async()=>{q(await vCopy(V.hash)?"Hash copied.":"Clipboard unavailable.")},children:V.hash.slice(0,14)+"…"}),E.jsx("td",{className:"py-2 text-muted-foreground text-xs",children:WV(V.createdAt)}),E.jsx("td",{className:"py-2",children:E.jsx("span",{className:`rounded-full border px-2 py-0.5 text-[11px] ${V.killed?"border-destructive/40 text-destructive":"border-success/40 text-success"}`,children:V.killed?"disabled":"active"})}),E.jsxs("td",{className:"py-2 text-right whitespace-nowrap flex items-center justify-end gap-2",children:[E.jsx(oA,{variant:"outline",className:"v-btn-ghost text-xs",disabled:V.killed,onClick:async()=>{if(V.killed)return q("Script is disabled — loader blocked.");q(await vCopy(sldr)?"Loader copied to clipboard!":"Clipboard unavailable.")},children:"Copy loader"}),E.jsx(oA,{variant:"outline",className:"v-btn-ghost text-xs",onClick:()=>{let fi=document.createElement("input");fi.type="file";fi.accept=".lua,.luau,.txt";fi.onchange=async(e)=>{let f=e.target.files?.[0];if(!f)return;if(f.size>5*1024*1024)return q("Maximum file size is 5 MB.");window.v26Build?.show("Updating script","Protecting new payload...");try{let src=await f.text(),obf=await vProtectAsync(src);window.v26Build?.set("Publishing","Uploading payload to server...");let r=await fetch("https://projectv26.space/l/host",{method:"POST",headers:{"Content-Type":"application/json"},body:JSON.stringify({hash:V.hash,owner:V.owner,name:f.name,lua:obf})});if(!r.ok){let err=await r.text();throw new Error("HTTP "+r.status+": "+err.slice(0,200))}fetch("/api/site/register",{method:"POST",headers:{"Content-Type":"application/json"},credentials:"same-origin",body:JSON.stringify({hash:V.hash,owner:V.owner,name:f.name.replace(/\.[^.]+$/,"")})}).catch(()=>{});let next=A.map(x=>x.hash===V.hash?{...x,name:f.name.replace(/\.[^.]+$/,""),size:new Blob([src]).size,createdAt:Date.now()}:x);Dq(W7.scripts,next);M(next);Z("script.update",f.name+" ("+V.hash.slice(0,8)+")");q("Script updated successfully!");}catch(err){q("Update failed: "+(err?.message||err))}finally{window.v26Build?.hide()}};fi.click();},children:"Update script"}),E.jsx(oA,{variant:"outline",className:"v-btn-ghost text-xs "+(V.killed?"text-success":"text-destructive"),onClick:()=>{let nk=!V.killed;vApi({action:nk?"kill":"revive",hash:V.hash,owner:V.owner}).then(ok=>{if(!ok)q("Server error updating kill status.")});let next=A.map(x=>(x.hash===V.hash||x.id===V.id)?{...x,killed:nk}:x);Dq(W7.scripts,next);M(next);Z(nk?"script.kill":"script.revive",V.name);q(nk?"Script disabled.":"Script reactivated.");},children:V.killed?"Reactivate":"Kill script"})]})]},V.id||V.hash)})]})]})})})]});}

function jO({scripts:A,keys:M,setKeys:Z,log:q,show:z}){let[,vTick]=n.useState(0);n.useEffect(()=>{let i=setInterval(()=>vTick(x=>x+1),1000);return()=>clearInterval(i)},[]);let[Y,V]=n.useState(""),[Q,U]=n.useState(7),[B,W]=n.useState("days"),[J,I]=n.useState(""),[hcd,setHcd]=n.useState(2),[hcu,setHcu]=n.useState("hours"),K=()=>{if(!Y)return z("Pick a script.");let N=B==="hours"?3600000:B==="days"?86400000:2592000000,O={id:"k_"+kz(8),key:UO(),scriptId:Y,createdAt:Date.now(),expiresAt:Q>0?Date.now()+Q*N:null,note:J,revoked:!1,hwidCooldown:hcd*(hcu==="minutes"?60000:hcu==="hours"?3600000:86400000),hwidResetAt:0};vApi({action:"mint",...vOwn(A,Y),key:O.key,expires:O.expiresAt,note:J,hwidCooldown:O.hwidCooldown}).then(ok=>{if(!ok)z("Server rejected key — re-upload this script and try again.")}),Z([O,...M]),q("key.mint",`${O.key} → ${Y} · ${Q}${B[0]}${J?" · "+J:""}`),z("Key minted."),I("")};return E.jsxs(E.Fragment,{children:[E.jsx(Cz,{title:"New Key",hint:"Choose a script and set the access period.",children:E.jsxs("div",{className:"grid grid-cols-4 gap-3 max-md:grid-cols-2",children:[E.jsx(yZ,{label:"Script",children:E.jsxs(yT,{className:"v-input",value:Y,onChange:(N)=>V(N.target.value),children:[E.jsx("option",{value:"",children:"— select —"}),A.map((N)=>E.jsx("option",{value:N.id,children:N.name},N.id))]})}),E.jsx(yZ,{label:"Amount (0 = never)",children:E.jsx("input",{className:"v-input",type:"number",min:0,value:Q,onChange:(N)=>U(Math.max(0,Number(N.target.value)||0))})}),E.jsx(yZ,{label:"Unit",children:E.jsxs(yT,{className:"v-input",value:B,onChange:(N)=>W(N.target.value),children:[E.jsx("option",{value:"hours",children:"Hours"}),E.jsx("option",{value:"days",children:"Days"}),E.jsx("option",{value:"months",children:"Months"})]})}),E.jsx(yZ,{label:"Note (optional)",children:E.jsx("input",{className:"v-input",value:J,onChange:(N)=>I(N.target.value),placeholder:"customer / tag"})}),E.jsx(yZ,{label:"HWID reset time (0 = no limit)",children:E.jsx("input",{className:"v-input",type:"number",min:0,value:hcd,onChange:e=>setHcd(Math.max(0,Number(e.target.value)||0))})}),E.jsx(yZ,{label:"Reset unit",children:E.jsxs(yT,{className:"v-input",value:hcu,onChange:e=>setHcu(e.target.value),children:[E.jsx("option",{value:"minutes",children:"Minutes"}),E.jsx("option",{value:"hours",children:"Hours"}),E.jsx("option",{value:"days",children:"Days"})]})}),E.jsx("div",{className:"flex items-end",children:E.jsx(oA,{variant:"default",className:"v-btn-primary",onClick:K,children:"Generate key"})})]})}),E.jsx(vHwidPanel,{keys:M,scripts:A,setKeys:Z,log:q,show:z}),E.jsx(Cz,{title:`All Keys (${M.length})`,children:E.jsx("div",{className:"overflow-x-auto",children:E.jsxs("table",{className:"w-full text-sm",children:[E.jsx("thead",{children:E.jsxs("tr",{className:"text-[11px] uppercase tracking-wider text-muted-foreground",children:[E.jsx("th",{className:"py-2 text-left font-semibold",children:"Key"}),E.jsx("th",{className:"py-2 text-left font-semibold",children:"Script"}),E.jsx("th",{className:"py-2 text-left font-semibold",children:"Expires"}),E.jsx("th",{className:"py-2 text-left font-semibold",children:"Status"}),E.jsx("th",{className:"py-2 text-left font-semibold",children:"Note"}),E.jsx("th",{})]})}),E.jsxs("tbody",{children:[M.length===0&&E.jsx("tr",{children:E.jsx("td",{colSpan:6,className:"py-3 text-muted-foreground",children:"No keys yet."})}),M.map((N)=>{let O=!!(N.expiresAt&&N.expiresAt<Date.now()),j=N.revoked?"revoked":O?"expired":"active",T=A.find((G)=>G.id===N.scriptId);return E.jsxs("tr",{className:"border-t border-border",children:[E.jsx("td",{className:"py-2 font-mono text-xs text-foreground cursor-pointer",title:"Click to copy",onClick:async()=>{z(await vCopy(N.key)?"Key copied.":"Clipboard unavailable.")},children:N.key}),E.jsx("td",{className:"py-2 text-foreground",children:T?.name||N.scriptId}),E.jsx("td",{className:"py-2 text-muted-foreground text-xs",children:N.expiresAt?E.jsxs("div",{children:[E.jsx("div",{children:WV(N.expiresAt)}),E.jsx("div",{className:"v-left",children:vLeft(N.expiresAt-Date.now())+" left"})]}):"never"}),E.jsx("td",{className:"py-2",children:E.jsx("span",{className:`rounded-full border px-2 py-0.5 text-[11px] ${j==="active"?"border-border text-foreground":"border-border text-muted-foreground"}`,children:j})}),E.jsx("td",{className:"py-2 text-muted-foreground text-xs",children:N.note||"—"}),E.jsxs("td",{className:"py-2 text-right whitespace-nowrap",children:[(()=>{let cd=N.hwidCooldown||0,rem=cd&&N.hwidResetAt?cd-(Date.now()-N.hwidResetAt):0;return E.jsx(oA,{variant:"outline",className:"v-btn-ghost text-xs mr-1",disabled:rem>0||N.revoked,title:"Click key text to copy",onClick:()=>vHwidReset(N,A,Z,M,q,z),children:rem>0?"HWID "+vLeft(rem):"Reset HWID"})})(),!N.revoked?E.jsx(oA,{variant:"outline",className:"v-btn-ghost text-xs",onClick:()=>{vApi({action:"ban",...vOwn(A,N.scriptId),key:N.key}),Z(M.map((G)=>G.id===N.id?{...G,revoked:!0}:G)),q("key.revoke",N.key),z("Revoked.")},children:"Revoke"}):E.jsx(oA,{variant:"outline",className:"v-btn-ghost text-xs",onClick:()=>{vApi({action:"unban",...vOwn(A,N.scriptId),key:N.key}),Z(M.map((G)=>G.id===N.id?{...G,revoked:!1}:G)),q("key.restore",N.key),z("Restored.")},children:"Restore"}),E.jsx(oA,{variant:"outline",className:"v-btn-ghost text-xs ml-1",onClick:()=>{vApi({action:"delete",...vOwn(A,N.scriptId),key:N.key}),Z(M.filter((G)=>G.id!==N.id)),q("key.delete",N.key),z("Deleted.")},children:"Delete"})]})]},N.id)})]})]})})})]})}function XO({scripts:A,setScripts:M,keys:Z,setKeys:q,log:z,show:Y}){return E.jsx(Cz,{title:`Scripts (${A.length})`,hint:"Enable or disable protected scripts.",children:E.jsx("div",{className:"overflow-x-auto",children:E.jsxs("table",{className:"w-full text-sm",children:[E.jsx("thead",{children:E.jsxs("tr",{className:"text-[11px] uppercase tracking-wider text-muted-foreground",children:[E.jsx("th",{className:"py-2 text-left font-semibold",children:"Name"}),E.jsx("th",{className:"py-2 text-left font-semibold",children:"Hash"}),E.jsx("th",{className:"py-2 text-left font-semibold",children:"Created"}),E.jsx("th",{className:"py-2 text-left font-semibold",children:"Size"}),E.jsx("th",{className:"py-2 text-left font-semibold",children:"Keys"}),E.jsx("th",{className:"py-2 text-left font-semibold",children:"State"}),E.jsx("th",{})]})}),E.jsxs("tbody",{children:[A.length===0&&E.jsx("tr",{children:E.jsx("td",{colSpan:7,className:"py-3 text-muted-foreground",children:"No scripts yet. Drop one on the Loader page."})}),A.map((V)=>E.jsxs("tr",{className:"border-t border-border",children:[E.jsx("td",{className:"py-2 text-foreground",children:V.name}),E.jsxs("td",{className:"py-2 font-mono text-xs text-muted-foreground",children:[V.hash.slice(0,14),"…"]}),E.jsx("td",{className:"py-2 text-xs text-muted-foreground",children:WV(V.createdAt)}),E.jsxs("td",{className:"py-2 text-xs text-muted-foreground",children:[V.size," B"]}),E.jsx("td",{className:"py-2 text-foreground",children:Z.filter((Q)=>Q.scriptId===V.id).length}),E.jsx("td",{className:"py-2",children:E.jsx("span",{className:`rounded-full border px-2 py-0.5 text-[11px] ${V.killed?"border-destructive/40 text-destructive":"border-success/40 text-success"}`,children:V.killed?"inactive":"active"})}),E.jsxs("td",{className:"py-2 text-right whitespace-nowrap",children:[E.jsx(oA,{variant:"outline",className:"v-btn-ghost text-xs mr-1",onClick:()=>{vApi({action:V.killed?"revive":"kill",hash:V.hash,owner:V.owner}).then(ok=>{if(!ok)Y("Server did not accept — re-upload this script.")}),M(A.map((Q)=>Q.id===V.id?{...Q,killed:!Q.killed}:Q)),z(V.killed?"script.revive":"script.kill",V.id),Y(V.killed?"Script reactivated.":"Script disabled.")},children:V.killed?"Reactivate":"Kill switch"}),E.jsx(oA,{variant:"outline",className:"v-btn-ghost text-xs",onClick:()=>{if(!confirm(`Delete "${V.name}" and all its keys?`))return;vDeleteProtectedScript(V.id).catch(err=>Y(vStorageMessage(err))),M(A.filter((Q)=>Q.id!==V.id)),q(Z.filter((Q)=>Q.scriptId!==V.id)),z("script.delete",V.id),Y("Deleted.")},children:"Delete"})]})]},V.id))]})]})})})}function OO({user:discordUser,onOut:M,show:Z}){
let A=vDiscordName(discordUser),key="v26.profile."+discordUser.id,[profile,setProfile]=n.useState(()=>wz(key,{name:A,photo:vDiscordAvatar(discordUser),language:"English",notify:true})),[open,setOpen]=n.useState(false),[name,setName]=n.useState(profile.name),[photo,setPhoto]=n.useState(profile.photo),[language,setLanguage]=n.useState("English"),[notify,setNotify]=n.useState(profile.notify!==false),[error,setError]=n.useState(""),[saving,setSaving]=n.useState(false),closeRef=n.useRef(null);
n.useEffect(()=>{if(!open)return;let previous=document.activeElement;closeRef.current?.focus();let handler=e=>{if(e.key==="Escape")setOpen(false);if(e.key==="Tab"){let items=Array.from(document.querySelectorAll('.v-account-dialog button,.v-account-dialog input:not([hidden]),.v-account-dialog select')).filter(x=>!x.disabled);let first=items[0],last=items[items.length-1];if(e.shiftKey&&document.activeElement===first){e.preventDefault();last?.focus()}else if(!e.shiftKey&&document.activeElement===last){e.preventDefault();first?.focus()}}};document.addEventListener("keydown",handler);let overflow=document.body.style.overflow;document.body.style.overflow="hidden";return()=>{document.removeEventListener("keydown",handler);document.body.style.overflow=overflow;previous?.focus()}},[open]);
function launch(){setName(profile.name);setPhoto(profile.photo);setLanguage("English");setNotify(profile.notify!==false);setError("");setOpen(true)}
async function save(){setError("");if(!name.trim())return setError("Name is required.");setSaving(true);try{let value={name:name.trim(),photo,language,notify};Dq(key,value);setProfile(value);setOpen(false);Z("Account settings saved.")}catch(err){setError(err.message)}finally{setSaving(false)}}
function upload(e){let f=e.target.files?.[0];if(!f)return;if(!f.type.startsWith("image/"))return setError("Select an image.");if(f.size>2097152)return setError("Photo maximum is 2 MB.");let reader=new FileReader();reader.onload=()=>{let img=new Image();img.onload=()=>{let canvas=document.createElement("canvas");canvas.width=canvas.height=160;let ctx=canvas.getContext("2d");if(!ctx)return;let size=Math.min(img.width,img.height);ctx.drawImage(img,(img.width-size)/2,(img.height-size)/2,size,size,0,0,160,160);setPhoto(canvas.toDataURL("image/jpeg",.85))};img.src=reader.result};reader.readAsDataURL(f)}
let avatar=(src,text)=>src?E.jsx("img",{src,alt:"Profile",className:"v-account-avatar"}):E.jsx("span",{className:"v-account-avatar",children:(text||"U")[0].toUpperCase()});
let field=(label,value,set,type="text")=>E.jsx(yZ,{label,children:E.jsx("input",{className:"v-input",type,value,onChange:e=>set(e.target.value),maxLength:type==="password"?128:24,autoComplete:type==="password"?"new-password":"off"})});
return E.jsxs("div",{className:"v-profile",children:[E.jsxs(oA,{className:"v-account-trigger","aria-label":"Profile settings",onClick:launch,children:[E.jsx("span",{className:"v-account-email",children:vDiscordName(discordUser)}),avatar(vDiscordAvatar(discordUser),vDiscordName(discordUser))]}),open&&E.jsx("div",{className:"v-account-overlay",onClick:e=>{if(e.target===e.currentTarget)setOpen(false)},children:E.jsxs("section",{role:"dialog","aria-modal":true,"aria-labelledby":"account-title",className:"v-account-dialog",children:[E.jsxs("header",{className:"v-account-heading",children:[E.jsxs("div",{children:[E.jsx("span",{className:"v-account-eyebrow",children:"PROJECT V2.6"}),E.jsx("h3",{id:"account-title",children:"Account Management"})]}),E.jsx(oA,{ref:closeRef,variant:"ghost",className:"v-account-close","aria-label":"Close account settings",onClick:()=>setOpen(false),children:"×"})]}),E.jsxs("div",{className:"v-account-section",children:[E.jsx("h4",{children:"Profile"}),E.jsxs("div",{className:"v-account-photo-row",children:[avatar(photo,name),E.jsxs("label",{className:"v-btn-ghost",children:["Change photo",E.jsx("input",{type:"file",accept:"image/*",hidden:true,onChange:upload})]}),photo&&E.jsx(oA,{variant:"ghost",className:"v-btn-ghost",onClick:()=>setPhoto(""),children:"Remove"})]}),field("Display name",name,setName),E.jsx(yZ,{label:"Discord username",children:E.jsx("input",{className:"v-input",type:"text",value:A,readOnly:true})})]}),E.jsxs("div",{className:"v-account-section",children:[E.jsx("h4",{children:"Preferences"}),E.jsx(yZ,{label:"Date & time format",children:E.jsxs("select",{className:"v-input",value:language,onChange:e=>setLanguage(e.target.value),children:[E.jsx("option",{children:"English"})]})}),E.jsxs("label",{className:"v-account-check",children:[E.jsx("input",{type:"checkbox",checked:notify,onChange:e=>setNotify(e.target.checked)}),"Status notifications"]})]}),error&&E.jsx("p",{role:"alert",className:"text-destructive",children:error}),E.jsxs("footer",{className:"v-account-actions",children:[E.jsx(oA,{variant:"outline",className:"v-btn-ghost",onClick:M,children:"Logout"}),E.jsx(oA,{className:"v-btn-primary",disabled:saving,onClick:save,children:saving?"Saving…":"Save changes"})]})]})})]});}
function vGearIcon(){return E.jsxs("svg",{width:16,height:16,viewBox:"0 0 24 24",fill:"none",stroke:"currentColor",strokeWidth:1.8,strokeLinecap:"round",strokeLinejoin:"round",children:[E.jsx("circle",{cx:12,cy:12,r:3}),E.jsx("path",{d:"M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 1 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 1 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 1 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 1 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"})]})}
function vSettings({user:A,refreshAuth,show:Q}){
let[conn,setConn]=n.useState(null);
let[bgTheme,setBgTheme]=n.useState(()=>{
try{return localStorage.getItem("v26_bg_theme")||"topo"}catch(_){return"topo"}
});

n.useEffect(()=>{
let live=true;
fetch("/api/discord-status",{method:"GET",credentials:"same-origin"})
.then(r=>r.ok?r.json():null)
.then(d=>{if(live)setConn(d)})
.catch(()=>{if(live)setConn(null)});
return()=>{live=false};
},[A]);

const selectTheme=themeKey=>{
setBgTheme(themeKey);
try{localStorage.setItem("v26_bg_theme",themeKey)}catch(_){}
if(window.setV26Theme)window.setV26Theme(themeKey);
if(window.v26Toast)window.v26Toast("Arka plan teması güncellendi.","success");
};

return E.jsxs("div",{className:"grid gap-6",children:[
E.jsx(Cz,{title:"WORKSPACE THEME & BACKGROUND",hint:"Choose your workspace background style. Changes are saved automatically.",children:E.jsxs("div",{className:"grid grid-cols-1 sm:grid-cols-2 gap-4",children:[
E.jsx("div",{onClick:()=>selectTheme("topo"),className:`cursor-pointer rounded-xl border p-4 transition-all duration-200 relative ${bgTheme==="topo"?"border-emerald-500/60 bg-emerald-500/10 shadow-[0_0_15px_rgba(16,185,129,0.15)]":"border-border bg-secondary/30 hover:border-muted-foreground/40 hover:bg-secondary/50"}`,children:E.jsxs("div",{className:"flex items-start justify-between gap-2",children:[
E.jsxs("div",{children:[
E.jsx("p",{className:"font-semibold text-sm text-foreground",children:"Topographic Grid"}),
E.jsx("p",{className:"text-xs text-muted-foreground mt-1 leading-relaxed",children:"Dark stealth aesthetic with subtle geometric elevation lines."})
]}),
bgTheme==="topo"?E.jsxs("span",{className:"inline-flex items-center gap-1.5 rounded-full border border-emerald-500/40 bg-emerald-500/20 px-2.5 py-0.5 text-[11px] font-medium text-emerald-400 shrink-0",children:[
E.jsx("span",{className:"h-1.5 w-1.5 rounded-full bg-emerald-400"}),
"Active"
]}):E.jsx("span",{className:"inline-flex items-center rounded-full border border-border px-2.5 py-0.5 text-[11px] text-muted-foreground shrink-0",children:"Select"})
]})}),
E.jsx("div",{onClick:()=>selectTheme("leaves"),className:`cursor-pointer rounded-xl border p-4 transition-all duration-200 relative ${bgTheme==="leaves"?"border-emerald-500/60 bg-emerald-500/10 shadow-[0_0_15px_rgba(16,185,129,0.15)]":"border-border bg-secondary/30 hover:border-muted-foreground/40 hover:bg-secondary/50"}`,children:E.jsxs("div",{className:"flex items-start justify-between gap-2",children:[
E.jsxs("div",{children:[
E.jsx("p",{className:"font-semibold text-sm text-foreground",children:"Falling White Leaves"}),
E.jsx("p",{className:"text-xs text-muted-foreground mt-1 leading-relaxed",children:"Ambient live animation of falling white leaves drifting smoothly across your workspace."})
]}),
bgTheme==="leaves"?E.jsxs("span",{className:"inline-flex items-center gap-1.5 rounded-full border border-emerald-500/40 bg-emerald-500/20 px-2.5 py-0.5 text-[11px] font-medium text-emerald-400 shrink-0",children:[
E.jsx("span",{className:"h-1.5 w-1.5 rounded-full bg-emerald-400"}),
"Active"
]}):E.jsx("span",{className:"inline-flex items-center rounded-full border border-border px-2.5 py-0.5 text-[11px] text-muted-foreground shrink-0",children:"Select"})
]})})
]})}),
E.jsx(Cz,{title:"DISCORD & BOT INTEGRATION",hint:"Your Discord account and bot server authority status.",children:E.jsxs("div",{className:"grid gap-4",children:[
E.jsxs("div",{className:"flex items-center justify-between gap-3 rounded-lg border border-border bg-secondary/40 px-4 py-3 max-sm:flex-col max-sm:items-start",children:[
E.jsxs("div",{children:[
E.jsx("p",{className:"text-xs uppercase tracking-wider text-muted-foreground",children:"Account"}),
E.jsx("p",{className:"mt-0.5 text-sm text-foreground break-all",children:vDiscordName(A)})
]}),
E.jsxs("span",{className:`inline-flex items-center gap-2 rounded-full border px-3 py-1 text-xs font-medium ${A?"border-emerald-500/30 text-emerald-400 bg-emerald-500/10":"border-border text-muted-foreground"}`,children:[
E.jsx("span",{className:`h-1.5 w-1.5 rounded-full ${A?"bg-emerald-400":"bg-muted-foreground"}`}),
A?"Connected & Authorized":"Not Connected"
]})
]}),
A?E.jsxs("div",{className:"rounded-lg border border-border bg-secondary/20 p-4 text-xs text-muted-foreground leading-relaxed",children:[
E.jsx("p",{className:"font-medium text-foreground mb-1",children:"Automatic Guild & Bot Authority"}),
E.jsx("p",{children:"Your bot and server ownership are automatically authorized and synced during Discord login. Manual link tokens and /claimownership commands have been retired."})
]}):E.jsxs("div",{className:"grid gap-3 pt-2",children:[
E.jsx("p",{className:"text-sm text-muted-foreground",children:"Please log in with Discord to access bot controls and server settings."}),
E.jsx(vDiscordLogin,{})
]})
]})})
]});
}
function EO({user:discordUser,onOut:M,refreshAuth}){let A=discordUser.id,[Z,q]=n.useState("dashboard"),[z,Y]=n.useState(()=>wz(W7.scripts,[]).map(({obf,...meta})=>meta)),[V,Q]=n.useState(()=>wz(W7.keys,[])),[U,B]=n.useState(()=>wz(W7.activity,[])),[W,J]=n.useState(""),[persistError,setPersistError]=n.useState(""),I=n.useRef(null);n.useEffect(()=>{vPrepareLargeStorage(wz(W7.scripts,[]))},[]);n.useEffect(()=>{let syncData=()=>{fetch("/api/site/sync",{credentials:"same-origin"}).then(r=>r.ok?r.json():null).then(d=>{if(!d||!d.ok)return;if(Array.isArray(d.scripts)&&d.scripts.length){Y(prev=>{let map=new Map(prev.map(s=>[s.hash,s]));for(let s of d.scripts){if(map.has(s.hash)){let ex=map.get(s.hash);map.set(s.hash,{...ex,name:s.name,killed:s.killed,owner:s.owner||ex.owner});}else{map.set(s.hash,s);}}let merged=Array.from(map.values()).slice(0,5);vSafePersist(W7.scripts,merged);return merged;});}if(Array.isArray(d.keys)&&d.keys.length){Q(prev=>{let kMap=new Map(prev.map(k=>[k.key,k]));for(let k of d.keys){if(kMap.has(k.key)){kMap.set(k.key,{...kMap.get(k.key),...k});}else{kMap.set(k.key,k);}}let merged=Array.from(kMap.values());vSafePersist(W7.keys,merged);return merged;});}}).catch(()=>{});};syncData();let si=setInterval(syncData,8000);return()=>clearInterval(si);},[]);n.useEffect(()=>{let handler=e=>setPersistError(e.detail);window.addEventListener("v26-storage-error",handler);return()=>window.removeEventListener("v26-storage-error",handler)},[]);n.useEffect(()=>{vSafePersist(W7.scripts,z)},[z]),n.useEffect(()=>{vSafePersist(W7.keys,V)},[V]),n.useEffect(()=>{vSafePersist(W7.activity,U)},[U]);n.useEffect(()=>{let sweep=()=>{let now=Date.now(),cur=wz(W7.keys,[]),gone=cur.filter(k=>k.expiresAt&&k.expiresAt<=now);Q(ks=>{let g=ks.filter(k=>k.expiresAt&&k.expiresAt<=now);return g.length?ks.filter(k=>!(k.expiresAt&&k.expiresAt<=now)):ks});if(gone.length)B(a=>[...gone.map(k=>({t:now,event:"key.expired",detail:k.key+" · auto-deleted"})),...a].slice(0,60))};sweep();let i=setInterval(sweep,1000);return()=>clearInterval(i)},[]);let K=(j)=>{if(wz("v26.profile."+A,{}).notify===false)return;if(J(j),I.current)clearTimeout(I.current);I.current=setTimeout(()=>J(""),1800)},N=(j,T)=>B((G)=>[{t:Date.now(),event:j,detail:T},...G].slice(0,60)),O=[{k:"dashboard",label:"Overview",ic:E.jsx(oY,{})},{k:"loader",label:"Protect",ic:E.jsx(aY,{})},{k:"keys",label:"Keys",ic:E.jsx(sY,{})},{k:"scripts",label:"Scripts",ic:E.jsx(PZ,{})},{k:"settings",label:"Settings",ic:E.jsx(vGearIcon,{})}];return E.jsxs(E.Fragment,{children:[E.jsxs("div",{className:"v-workspace",children:[E.jsxs("aside",{className:"v-sidebar",children:[E.jsx(vT,{}),E.jsx("nav",{className:"mt-6 grid gap-1",children:O.map((j)=>E.jsxs(oA,{variant:"ghost",onClick:()=>q(j.k),className:`flex items-center gap-2.5 rounded-md px-3 py-2 text-left text-[13px] transition ${Z===j.k?"bg-accent text-foreground border border-border":"text-muted-foreground hover:bg-secondary hover:text-foreground border border-transparent"}`,children:[E.jsx("span",{className:"v-nav-icon",children:j.ic}),j.label]},j.k))}),E.jsxs("div",{className:"v-sidebar-footer",children:[E.jsx("span",{className:"v-status-dot"})," Local workspace",E.jsx("span",{children:"V2.6"})]})]}),E.jsxs("main",{className:"v-main",children:[E.jsxs("header",{className:"v-header",children:[E.jsx("h2",{className:"v-page-title",children:O.find((j)=>j.k===Z)?.label}),E.jsx(OO,{user:discordUser,onOut:M,show:K})]}),E.jsxs("div",{className:"v-view",children:[persistError&&E.jsx("p",{role:"alert",className:"text-destructive text-sm",children:persistError}),Z==="dashboard"&&E.jsx(DO,{scripts:z,keys:V,activity:U}),Z==="loader"&&E.jsx(NO,{scripts:z,setScripts:Y,log:N,show:K}),Z==="keys"&&E.jsx(jO,{scripts:z,keys:V,setKeys:Q,log:N,show:K}),Z==="scripts"&&E.jsx(XO,{scripts:z,setScripts:Y,keys:V,setKeys:Q,log:N,show:K}),Z==="settings"&&E.jsx(vSettings,{user:discordUser,refreshAuth,show:K})]},Z),E.jsxs("footer",{className:"v-footer",children:[E.jsx("span",{children:"PROJECT V2.6"}),E.jsxs("span",{children:["Local workspace ",E.jsx("i",{})]})]})]})]}),W&&E.jsx("div",{className:"fixed bottom-5 right-5 rounded-lg border border-border bg-card px-4 py-2.5 text-sm text-foreground shadow-xl v-toast",children:W})]})}function RO(){return E.jsxs("div",{className:"v-boot",role:"status","aria-label":"Loading workspace",children:[E.jsxs("div",{className:"v-boot-inner",children:[E.jsx("img",{className:"v-boot-logo",src:O1.url,alt:"PROJECT V2.6"}),E.jsx("div",{className:"v-boot-title",children:"PROJECT V2.6"}),E.jsx("p",{className:"v-boot-slogan",children:"Your code. Your control."}),E.jsx("div",{className:"v-boot-track",children:E.jsx("div",{})}),E.jsx("div",{className:"v-boot-text",children:"Preparing your workspace"})]}),E.jsx("span",{className:"v-boot-edition",children:"SCRIPT PROTECTION / V2.6"})]})}function vDiscordName(user){return user?.username||user?.global_name||user?.display_name||"Discord user"}
function vDiscordAvatar(user){if(!user)return "";if(user.avatar_url)return user.avatar_url;if(user.avatar?.startsWith("https://"))return user.avatar;if(user.avatar&&user.id)return `https://cdn.discordapp.com/avatars/${user.id}/${user.avatar}.png`;return ""}
async function vReadSession(){const r=await fetch("/api/me",{method:"GET",credentials:"same-origin"});if(r.status===401)return null;if(!r.ok)throw new Error("Could not check your Discord session. Please try again.");const d=await r.json();if(d.authenticated===false)return null;const raw=d.user||d.discord_user||d;if(!raw||d.authenticated!==true&&!raw.id&&!raw.discord_id)return null;const user={...raw,id:raw.id||raw.discord_id};return user.id&&vDiscordName(user)!=="Discord user"?user:null}
function E1(){let[land,setLand]=n.useState(true),[user,setUser]=n.useState(null),[loading,setLoading]=n.useState(true),[error,setError]=n.useState("");async function refreshAuth(){try{setUser(await vReadSession());setError("")}catch(e){setUser(null);setError("")}finally{setLoading(false)}}n.useEffect(()=>{refreshAuth()},[]);async function logout(){try{let r=await fetch("/auth/logout",{method:"POST",credentials:"same-origin"});if(!r.ok)throw new Error("Logout failed. Please try again.");setLand(false);await refreshAuth()}catch(e){window.v26Toast?.(e.message,"error")}}return E.jsxs(E.Fragment,{children:[E.jsx("div",{className:"v-bg"}),loading?E.jsx(RO,{}):user?E.jsx(EO,{user,onOut:logout,refreshAuth}):E.jsxs(E.Fragment,{children:[error&&E.jsx("p",{role:"alert",className:"v-session-error",children:error}),land?E.jsx(vLanding,{onGo:()=>setLand(false)}):E.jsx(KO,{})]})]})}var gT=y(uA(),1);fT.createRoot(document.getElementById("root")).render(gT.jsx(E1,{}));})();
</script>
<script id="v26-ux-script">
(function(){
  "use strict";
  if (window.__v26ux) return; window.__v26ux = true;

  /* ---------------- toast ---------------- */
  var tw = null;
  function toasts(){
    if(!tw){ tw = document.createElement("div"); tw.className="v26-toasts"; document.body.appendChild(tw); }
    return tw;
  }
  function toast(msg, kind){
    var el = document.createElement("div");
    el.className = "v26-toast " + (kind||"");
    var dot = document.createElement("i");
    var tx  = document.createElement("div");
    tx.textContent = String(msg);
    el.appendChild(dot); el.appendChild(tx);
    toasts().appendChild(el);
    setTimeout(function(){
      el.classList.add("v26-out");
      setTimeout(function(){ el.remove(); }, 260);
    }, 4600);
  }
  window.v26Toast = toast;

  /* ---------------- themed dialog ---------------- */
  function dialog(opts){
    return new Promise(function(resolve){
      var ovl = document.createElement("div");
      ovl.className = "v26-ovl";
      ovl.innerHTML =
        '<div class="v26-dlg" role="dialog" aria-modal="true">' +
          '<div class="v26-dlg-top"></div>' +
          '<div class="v26-dlg-body">' +
            '<div class="v26-dlg-brand"><i></i><span>PROJECT V2.6</span></div>' +
            '<h3></h3><p></p>' +
          '</div>' +
          '<div class="v26-dlg-foot"></div>' +
        '</div>';
      ovl.querySelector("h3").textContent = opts.title || "Confirm";
      ovl.querySelector("p").textContent  = opts.body  || "";
      var foot = ovl.querySelector(".v26-dlg-foot");

      function close(val){
        ovl.classList.add("v26-out");
        setTimeout(function(){ ovl.remove(); resolve(val); }, 180);
      }
      if (opts.cancel !== false){
        var c = document.createElement("button");
        c.className = "v26-b"; c.type="button";
        c.textContent = opts.cancelText || "Cancel";
        c.onclick = function(){ close(false); };
        foot.appendChild(c);
      }
      var k = document.createElement("button");
      k.className = "v26-b " + (opts.danger ? "v26-b-dng" : "v26-b-pri");
      k.type = "button";
      k.textContent = opts.okText || "Confirm";
      k.onclick = function(){ close(true); };
      foot.appendChild(k);

      ovl.addEventListener("click", function(e){ if(e.target===ovl) close(false); });
      document.addEventListener("keydown", function esc(e){
        if(e.key==="Escape"){ document.removeEventListener("keydown", esc); close(false); }
      });
      document.body.appendChild(ovl);
      setTimeout(function(){ k.focus(); }, 60);
    });
  }
  window.v26Dialog = dialog;

  /* ----- replace native confirm() with the themed dialog -----
     confirm() is synchronous and our dialog is not, so we remember the
     click that triggered it, return false once, then replay the click
     after the user approves in the themed dialog. */
  var lastClick = null, armed = false;
  document.addEventListener("click", function(e){ lastClick = e.target; }, true);

  var nativeConfirm = window.confirm.bind(window);
  window.confirm = function(message){
    if (armed){ armed = false; return true; }
    var target = lastClick;
    var msg = String(message == null ? "" : message);
    var danger = /delete|remove|revoke|kill|wipe|reset|destroy/i.test(msg);
    dialog({
      title:  danger ? "Delete confirmation" : "Please confirm",
      body:   msg,
      okText: danger ? "Delete" : "Confirm",
      danger: danger
    }).then(function(ok){
      if (!ok || !target || !document.contains(target)) return;
      armed = true;
      try { target.click(); } finally { setTimeout(function(){ armed = false; }, 0); }
    });
    return false;
  };
  window.__v26NativeConfirm = nativeConfirm;

  /* ----- replace native alert() with a themed dialog ----- */
  window.alert = function(message){
    var msg = String(message == null ? "" : message);
    var err = /fail|error|invalid|denied|unable|cannot|could not|not enough/i.test(msg);
    dialog({ title: err ? "Something went wrong" : "Notice", body: msg,
             okText: "Got it", cancel: false });
  };

  /* ----- replace native prompt() (returns null, shows a notice) ----- */
  var nativePrompt = window.prompt.bind(window);
  window.prompt = function(message, def){ return nativePrompt(message, def); };

  /* ---------------- build / loader progress overlay ---------------- */
  var buildEl = null;
  function buildShow(title, sub){
    if (buildEl) { buildSet(title, sub); return; }
    buildEl = document.createElement("div");
    buildEl.className = "v26-build";
    buildEl.innerHTML =
      '<div class="v26-build-in">' +
        '<div class="v26-build-ring"></div>' +
        '<h4></h4><span></span>' +
        '<div class="v26-build-track"><i></i></div>' +
      '</div>';
    document.body.appendChild(buildEl);
    buildSet(title, sub);
  }
  function buildSet(title, sub){
    if(!buildEl) return;
    buildEl.querySelector("h4").textContent = title || "Working...";
    buildEl.querySelector("span").textContent = sub || "";
  }
  function buildHide(){
    if(!buildEl) return;
    var el = buildEl; buildEl = null;
    el.style.transition = "opacity .25s ease";
    el.style.opacity = "0";
    setTimeout(function(){ el.remove(); }, 260);
  }
  window.v26Build = { show: buildShow, set: buildSet, hide: buildHide };

  /* The Protect flow owns this overlay from start through verified storage. */

  /* ---------------- English-only guard for leftover strings ---------------- */
  var TR = {
    "Server error": "Server error",
    "Sunucu hatasi": "Server error",
    "Bir hata oluştu": "Something went wrong",
    "Yükleniyor": "Loading",
    "Kaydedildi": "Saved",
    "Kopyalandı": "Copied",
    "Hata": "Error"
  };
  function scrub(root){
    var w = document.createTreeWalker(root, NodeFilter.SHOW_TEXT, null);
    var n;
    while ((n = w.nextNode())){
      var v = n.nodeValue;
      if (!v) continue;
      for (var k in TR){ if (v.indexOf(k) !== -1) n.nodeValue = v = v.split(k).join(TR[k]); }
    }
  }

  /* ---------------- view transition on route/view change ---------------- */
  function boot(){
    var root = document.getElementById("root");
    if (!root) return;
    scrub(root);
    var t = null;
    new MutationObserver(function(muts){
      for (var i=0;i<muts.length;i++){
        for (var j=0;j<muts[i].addedNodes.length;j++){
          var node = muts[i].addedNodes[j];
          if (node.nodeType === 1) scrub(node);
        }
      }

    }).observe(root, { childList: true, subtree: true });
  }
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", boot);
  else boot();

  /* surface the app's own storage errors as themed toasts */
  window.addEventListener("v26-storage-error", function(e){
    toast((e && e.detail) || "Browser storage error.", "err");
  });
})();
</script>
<div id="v-loading"><div class="sp"></div><div class="tx">Loading...</div></div><script>
(function(){var L=document.getElementById('v-loading'),T=L&&L.querySelector('.tx');
var re=/(create account|sign up|register|hesap olu|kay[ıi]t)/i;
document.addEventListener('click',function(e){var b=e.target.closest&&e.target.closest('button');if(!L||!T||!b||b.disabled)return;var t=(b.textContent||'').trim();if(!re.test(t))return;
T.textContent='Creating account...';L.classList.add('on');setTimeout(function(){L.classList.remove('on')},1400);},true);})();
</script>
<canvas id="v-leaves-canvas"></canvas>
<script id="v26-ambient-engine">
(function() {
  const canvas = document.getElementById('v-leaves-canvas');
  if (!canvas) return;
  const ctx = canvas.getContext('2d');
  let animationId = null;
  let leaves = [];
  const LEAF_COUNT = 36;

  function resize() {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
  }
  window.addEventListener('resize', resize);
  resize();

  class Leaf {
    constructor(randomY = false) {
      this.reset(randomY);
    }
    reset(randomY = false) {
      this.x = Math.random() * canvas.width;
      this.y = randomY ? Math.random() * canvas.height : -30 - Math.random() * 50;
      this.size = 8 + Math.random() * 10;
      this.speedY = 1.0 + Math.random() * 1.4;
      this.speedX = (Math.random() - 0.5) * 0.7;
      this.angle = Math.random() * Math.PI * 2;
      this.angularSpeed = (Math.random() - 0.5) * 0.025;
      this.swingSpeed = 0.015 + Math.random() * 0.02;
      this.swingOffset = Math.random() * Math.PI * 2;
      this.opacity = 0.35 + Math.random() * 0.45;
      this.aspect = 0.45 + Math.random() * 0.35;
    }
    update(time) {
      this.y += this.speedY;
      this.x += this.speedX + Math.sin(time * this.swingSpeed + this.swingOffset) * 0.7;
      this.angle += this.angularSpeed;

      if (this.y > canvas.height + 40 || this.x < -60 || this.x > canvas.width + 60) {
        this.reset(false);
      }
    }
    draw(ctx) {
      ctx.save();
      ctx.translate(this.x, this.y);
      ctx.rotate(this.angle);
      ctx.beginPath();
      ctx.ellipse(0, 0, this.size * this.aspect, this.size, 0, 0, Math.PI * 2);
      ctx.fillStyle = `rgba(240, 244, 255, ${this.opacity})`;
      ctx.shadowColor = 'rgba(255, 255, 255, 0.4)';
      ctx.shadowBlur = 4;
      ctx.fill();
      
      ctx.beginPath();
      ctx.moveTo(0, -this.size * 0.85);
      ctx.lineTo(0, this.size * 0.85);
      ctx.strokeStyle = `rgba(255, 255, 255, ${this.opacity * 0.6})`;
      ctx.lineWidth = 0.75;
      ctx.stroke();
      ctx.restore();
    }
  }

  function initLeaves() {
    leaves = [];
    for (let i = 0; i < LEAF_COUNT; i++) {
      leaves.push(new Leaf(true));
    }
  }

  let startTime = performance.now();
  function loop(now) {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    const elapsed = now - startTime;
    for (let i = 0; i < leaves.length; i++) {
      leaves[i].update(elapsed);
      leaves[i].draw(ctx);
    }
    animationId = requestAnimationFrame(loop);
  }

  function start() {
    if (animationId) return;
    initLeaves();
    startTime = performance.now();
    animationId = requestAnimationFrame(loop);
  }

  function stop() {
    if (animationId) {
      cancelAnimationFrame(animationId);
      animationId = null;
    }
    ctx.clearRect(0, 0, canvas.width, canvas.height);
  }

  window.setV26Theme = function(theme) {
    if (theme === 'leaves') {
      document.body.classList.add('theme-leaves');
      start();
    } else {
      document.body.classList.remove('theme-leaves');
      stop();
    }
  };

  const initialTheme = localStorage.getItem('v26_bg_theme') || 'topo';
  window.setV26Theme(initialTheme);
})();
</script>
</body></html>