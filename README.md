# Unseen

**Swift Student Challenge 2026**

Step into worlds you've never experienced. Unseen lets you simulate color blindness, vision impairment, hearing loss, and limited mobility — so you can understand why accessible design matters.

---

## The 4 Experiences

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

## Data Sources

Stats and simulation methods used in the app:

### Color Blindness

| Statistic | Value | Source |
|-----------|-------|--------|
| Overall prevalence | ~8% of men, ~0.5% of women | [MedlinePlus Genetics](https://medlineplus.gov/genetics/condition/color-vision-deficiency/), [Nature: Eye](https://www.nature.com/articles/eye2009251) |
| Protanopia | ~1% of males | [Vision Center](https://www.visioncenter.org/resources/color-blind-statistics/), [Colour Blindness](https://www.colour-blindness.com/general/prevalence/) |
| Deuteranopia | ~1% of males | Same as above |
| Tritanopia | ~1 in 15,000 (affects both sexes equally) | [Vision Center](https://www.visioncenter.org/conditions/tritanopia/), [Britannica](https://www.britannica.com/science/tritanopia) |
| Achromatopsia | ~1 in 30,000 people | [MedlinePlus](https://medlineplus.gov/genetics/condition/achromatopsia/), [NIH Rare Diseases](https://www.rarediseases.info.nih.gov/diseases/15015/achromatopsia) |

**Simulation:** SwiftUI `saturation` and `colorMultiply`. Model includes Brettel/Viénot/Mollon (1997) matrices; [paper](https://opg.optica.org/josaa/abstract.cfm?uri=josaa-14-10-2647).

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

**Simulation:** Low-pass filter (`cutoff = 20000 × 0.04^level` Hz) — high frequencies drop first, like real sensorineural loss. [NCBI](https://www.ncbi.nlm.nih.gov/books/NBK565860/)

---

### Limited Mobility

| Statistic | Value | Source |
|-----------|-------|--------|
| Osteoarthritis | 595 million globally (2020) | [Lancet GBD 2021](https://www.thelancet.com/journals/lanrhe/article/PIIS2665-9913(23)00163-7/fulltext), [WHO Musculoskeletal](https://www.who.int/news-room/fact-sheets/detail/musculoskeletal-conditions) |
| Parkinson's disease | 11.77 million globally (2021) | [WHO Fact Sheet](https://www.who.int/news-room/fact-sheets/detail/parkinson-disease), [GBD 2021](https://pubmed.ncbi.nlm.nih.gov/39868382/) |

**Design guidance:** 44×44 pt minimum touch target — [Apple HIG: Layout](https://developer.apple.com/design/human-interface-guidelines/layout)

---

## Requirements

iOS 16.0+ · Xcode 15+ · Swift 6

---

Ketan Sharma — SSC 2026
