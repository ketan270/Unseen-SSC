# Unseen

### Step into worlds you've never experienced

**Swift Student Challenge 2026 Submission**

Unseen is an educational iOS app that builds **empathy and understanding** by simulating how people with different disabilities experience digital interfaces and the world around them. Through 4 interactive experiences, users discover why accessible design matters.

---

## About the App

Unseen offers **4 interactive experiences** that let you step into the perspectives of millions of people worldwide:

| Experience | What You'll Experience |
|------------|------------------------|
| **Color Blindness** | See through protanopia, deuteranopia, tritanopia, and achromatopsia — traffic lights, charts, and UI become challenging |
| **Vision Impairment** | Blur, distortion, and blind spots from myopia, hyperopia, astigmatism, and presbyopia |
| **Hearing Loss** | Muffled sounds, high-frequency loss, and tinnitus — experience why captions and visual alerts matter |
| **Limited Mobility** | Hand tremors, stiffness, and miss-taps that make precise touch interactions difficult |

---

## Technical Implementation

- **SwiftUI** — Native iOS UI with `NavigationStack`, `Toolbar`, `NavigationLink`, and system components
- **AVFoundation** — `AVAudioEngine`, `AVAudioPlayerNode`, `AVSpeechSynthesizer`; real-time low-pass filtering for hearing loss simulation
- **Core Image** — `CIFilter.gaussianBlur`, `CIFilter.motionBlur`, `CIFilter.colorControls` for vision impairment (myopia, hyperopia, astigmatism, presbyopia)
- **Accessibility** — `accessibilityLabel` and `accessibilityValue` on sliders and interactive elements (VoiceOver-ready); Apple HIG–aligned design

---

## Data Sources & Citations

All statistics and scientific references used in Unseen are from peer-reviewed research and official health organizations.

### Color Blindness

| Statistic | Value | Source |
|-----------|-------|--------|
| Overall prevalence | ~8% of men, ~0.5% of women | [MedlinePlus Genetics](https://medlineplus.gov/genetics/condition/color-vision-deficiency/), [Nature: Eye](https://www.nature.com/articles/eye2009251) |
| Protanopia | ~1% of males | [Vision Center](https://www.visioncenter.org/resources/color-blind-statistics/), [Colour Blindness](https://www.colour-blindness.com/general/prevalence/) |
| Deuteranopia | ~1% of males | Same as above |
| Tritanopia | ~1 in 15,000 (affects both sexes equally) | [Vision Center](https://www.visioncenter.org/conditions/tritanopia/), [Britannica](https://www.britannica.com/science/tritanopia) |
| Achromatopsia | ~1 in 30,000 people | [MedlinePlus](https://medlineplus.gov/genetics/condition/achromatopsia/), [NIH Rare Diseases](https://www.rarediseases.info.nih.gov/diseases/15015/achromatopsia) |

**Simulation:** Simplified simulation using SwiftUI `saturation` and `colorMultiply` modifiers for educational purposes. The app references *Brettel, Viénot & Mollon (1997)* — the gold standard for dichromat simulation — in the model; [paper](https://opg.optica.org/josaa/abstract.cfm?uri=josaa-14-10-2647).

---

### Vision Impairment

| Statistic | Value | Source |
|-----------|-------|--------|
| Adults needing vision correction | ~75% | [Lens.com](https://www.lens.com/questions-answered/what-percentage-of-the-population-wears-glasses/), [American Academy of Ophthalmology](https://www.aao.org/eye-health/glasses-contacts/midlife-adults) |
| Myopia | 30–90% (varies by region, highest in East Asia) | WHO, regional epidemiological studies |
| Hyperopia | ~25% of population | Standard ophthalmology references |
| Astigmatism | ~33% of population | Standard ophthalmology references |
| Presbyopia | Nearly 100% of people over 45 | [AAO](https://www.aao.org/eye-health/glasses-contacts/midlife-adults) |

**Design guidance:** Apple Human Interface Guidelines — [Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)

---

### Hearing Loss

| Statistic | Value | Source |
|-----------|-------|--------|
| Global prevalence | 1.57 billion (1 in 5 people) | [WHO Fact Sheet](https://www.who.int/news-room/fact-sheets/deafness-and-hearing-loss), [Lancet GBD 2019](https://www.thelancet.com/journals/lancet/article/PIIS0140-6736(21)00516-X/fulltext) |
| Moderate or worse | 403 million (after hearing aid adjustment) | Global Burden of Disease Study 2019 |

**Simulation science:** Sensorineural hearing loss typically affects high frequencies first (base of cochlea). The app uses an exponential low-pass filter: `cutoff = 20000 × 0.04^level` Hz, matching the characteristic audiogram pattern. [NCBI: Sensorineural Hearing Loss](https://www.ncbi.nlm.nih.gov/books/NBK565860/)

**Speech formants:** F0–F5 formant structure (200–6500 Hz) models how consonants disappear before vowels as hearing loss increases — based on standard audiological formant research.

---

### Limited Mobility

| Statistic | Value | Source |
|-----------|-------|--------|
| Osteoarthritis | 595 million globally (2020) | [Lancet GBD 2021](https://www.thelancet.com/journals/lanrhe/article/PIIS2665-9913(23)00163-7/fulltext), [WHO Musculoskeletal](https://www.who.int/news-room/fact-sheets/detail/musculoskeletal-conditions) |
| Parkinson's disease | 11.77 million globally (2021) | [WHO Fact Sheet](https://www.who.int/news-room/fact-sheets/detail/parkinson-disease), [GBD 2021](https://pubmed.ncbi.nlm.nih.gov/39868382/) |

**Design guidance:** 44×44 pt minimum touch target — [Apple HIG: Layout](https://developer.apple.com/design/human-interface-guidelines/layout)

---

## Design Principles

All design tips in the app align with:

- **Apple Human Interface Guidelines** — Accessibility, Layout, and Interaction
- **WCAG 2.1** — Web Content Accessibility Guidelines
- **WHO World Report on Hearing** — Recommendations for accessible design

---

## Requirements

- iOS 16.0+
- Xcode 15+ (Swift 6)
- Swift Package or Xcode project

---

## Author

**Ketan Sharma** — Swift Student Challenge 2026

---

## License

This project was created for the Apple Swift Student Challenge. All statistics and scientific references are cited above. Simulation algorithms are based on published research.
