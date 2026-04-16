import { Expert, MatchConditions, MatchResult, ScoreBreakdown, MatchReason, FunnelStep } from './types';
import { experts } from './experts';

function calculateFieldMatch(expert: Expert, conditions: MatchConditions): number {
  if (!conditions.specialty) return 70;
  const hasSpecialty = expert.specialties.includes(conditions.specialty);
  if (!hasSpecialty) return 15;

  let score = 60;
  const years = expert.specialtyExperience[conditions.specialty] || 0;
  score += Math.min(years / 15, 1) * 30;

  if (conditions.documentType) {
    const docCount = expert.documentExperience[conditions.documentType] || 0;
    score += Math.min(docCount / 50, 1) * 10;
  }

  return Math.min(Math.round(score), 100);
}

function calculateQualification(expert: Expert, conditions: MatchConditions): number {
  if (conditions.certifications.length === 0) return 70;

  let totalScore = 0;
  for (const reqCert of conditions.certifications) {
    const hasCert = expert.certifications.some(c => c.name === reqCert);
    if (hasCert) {
      totalScore += 100;
    } else if (reqCert === 'AITe 번역전문가 1급') {
      const has2 = expert.certifications.some(c => c.name === 'AITe 번역전문가 2급');
      totalScore += has2 ? 40 : 0;
    } else if (reqCert === 'AITe 번역전문가 2급') {
      const has1 = expert.certifications.some(c => c.name === 'AITe 번역전문가 1급');
      totalScore += has1 ? 100 : 0;
    } else {
      const hasAnyCert = expert.certifications.length > 0;
      totalScore += hasAnyCert ? 30 : 0;
    }
  }

  return Math.round(totalScore / conditions.certifications.length);
}

function calculateExperience(expert: Expert, conditions: MatchConditions): number {
  const generalScore = Math.min(expert.experienceYears / 15, 1) * 50;

  let docScore = 30;
  if (conditions.documentType) {
    const docCount = expert.documentExperience[conditions.documentType] || 0;
    docScore = Math.min(docCount / 50, 1) * 30;
  }

  let specScore = 20;
  if (conditions.specialty) {
    const specYears = expert.specialtyExperience[conditions.specialty] || 0;
    specScore = Math.min(specYears / 10, 1) * 20;
  }

  return Math.round(generalScore + docScore + specScore);
}

function calculatePerformance(expert: Expert): number {
  const ratingScore = (expert.rating / 5.0) * 50;
  const onTimeScore = (expert.onTimeRate / 100) * 30;
  const completionScore = Math.min(expert.completedProjects / 200, 1) * 20;
  return Math.round(ratingScore + onTimeScore + completionScore);
}

function calculateUrgency(expert: Expert, conditions: MatchConditions): number {
  if (conditions.urgency === 'normal') return 100;
  return expert.urgentAvailable ? 100 : 30;
}

function generateReasons(expert: Expert, conditions: MatchConditions): MatchReason[] {
  const reasons: MatchReason[] = [];

  if (conditions.specialty) {
    const years = expert.specialtyExperience[conditions.specialty] || 0;
    if (years > 0) {
      const suffix = conditions.minExperience ? ` (요구: ${conditions.minExperience}년+)` : '';
      reasons.push({
        text: `${conditions.specialty} 분야 경력 ${years}년${suffix}`,
        met: !conditions.minExperience || years >= conditions.minExperience,
      });
    } else {
      reasons.push({ text: `${conditions.specialty} 분야 경력 없음`, met: false });
    }
  }

  for (const reqCert of conditions.certifications) {
    const hasCert = expert.certifications.some(c => c.name === reqCert);
    if (hasCert) {
      reasons.push({ text: `${reqCert} 보유`, met: true });
    } else {
      const altCert = expert.certifications[0];
      if (altCert) {
        reasons.push({ text: `${altCert.name} 보유 (요구: ${reqCert})`, met: false });
      } else {
        reasons.push({ text: `${reqCert} 미보유`, met: false });
      }
    }
  }

  if (conditions.documentType) {
    const count = expert.documentExperience[conditions.documentType] || 0;
    reasons.push({
      text: `${conditions.documentType} 번역 ${count}건 경험`,
      met: count > 0,
    });
  }

  if (conditions.urgency !== 'normal') {
    reasons.push({
      text: expert.urgentAvailable ? '긴급 대응 가능' : '긴급 대응 불가',
      met: expert.urgentAvailable,
    });
  }

  reasons.push({
    text: `납기 준수율 ${expert.onTimeRate}%`,
    met: expert.onTimeRate >= 95,
  });

  return reasons;
}

function generateAiSummary(expert: Expert, conditions: MatchConditions, score: number): string {
  const specYears = conditions.specialty ? (expert.specialtyExperience[conditions.specialty] || 0) : expert.experienceYears;
  const certNames = expert.certifications.map(c => c.name).join(', ');
  const docCount = conditions.documentType ? (expert.documentExperience[conditions.documentType] || 0) : 0;

  let summary = '';
  if (conditions.specialty) {
    summary += `${conditions.specialty}`;
    if (conditions.documentType) summary += `(${conditions.documentType})`;
    summary += ` 분야 ${specYears}년 경력`;
  } else {
    summary += `${expert.experienceYears}년 경력의 전문 번역가`;
  }

  if (certNames) {
    summary += `에 ${certNames}을(를) 보유하고 있으며, `;
  } else {
    summary += `이며, `;
  }

  if (docCount > 0 && conditions.documentType) {
    summary += `유사 프로젝트(${conditions.documentType} 번역) ${docCount}건의 실적과 `;
  }

  summary += `${expert.onTimeRate}%의 납기 준수율을 기록하고 있습니다. `;

  if (conditions.urgency !== 'normal' && expert.urgentAvailable) {
    summary += '긴급 대응이 가능하여 ';
  }

  summary += `이번 프로젝트에 적합도 ${score}%로 `;
  if (score >= 95) summary += '가장 적합한 전문가입니다.';
  else if (score >= 90) summary += '매우 적합한 전문가입니다.';
  else if (score >= 85) summary += '적합한 전문가입니다.';
  else summary += '고려할 만한 전문가입니다.';

  return summary;
}

export function calculateMatches(conditions: MatchConditions): MatchResult[] {
  const languageFiltered = experts.filter(expert =>
    expert.languages.some(l => l.from === conditions.sourceLang && l.to === conditions.targetLang)
  );

  const results: MatchResult[] = languageFiltered.map(expert => {
    const breakdown: ScoreBreakdown = {
      fieldMatch: calculateFieldMatch(expert, conditions),
      qualification: calculateQualification(expert, conditions),
      experience: calculateExperience(expert, conditions),
      performance: calculatePerformance(expert),
      urgency: calculateUrgency(expert, conditions),
    };

    const score = Math.round(
      breakdown.fieldMatch * 0.30 +
      breakdown.qualification * 0.25 +
      breakdown.experience * 0.20 +
      breakdown.performance * 0.15 +
      breakdown.urgency * 0.10
    );

    const reasons = generateReasons(expert, conditions);
    const aiSummary = generateAiSummary(expert, conditions, score);

    return { expert, score, breakdown, reasons, aiSummary };
  });

  return results.sort((a, b) => b.score - a.score);
}

export function calculateFunnel(conditions: MatchConditions): FunnelStep[] {
  const TOTAL = 203;
  const steps: FunnelStep[] = [];
  let current = TOTAL;

  steps.push({ label: '전체 등록 전문가', count: TOTAL, total: TOTAL });

  if (conditions.sourceLang && conditions.targetLang) {
    const langRatios: Record<string, number> = {
      '한국어→영어': 0.70,
      '한국어→일본어': 0.45,
      '한국어→중국어': 0.40,
      '영어→한국어': 0.55,
      '일본어→한국어': 0.25,
      '중국어→한국어': 0.22,
    };
    const key = `${conditions.sourceLang}→${conditions.targetLang}`;
    const ratio = langRatios[key] || 0.30;
    current = Math.round(TOTAL * ratio);
    steps.push({ label: `${conditions.sourceLang}→${conditions.targetLang} 가능`, count: current, total: TOTAL });
  }

  if (conditions.specialty) {
    const specialtyRatios: Record<string, number> = {
      '법률': 0.63, '의료': 0.45, 'IT': 0.58, '금융': 0.50,
      '마케팅': 0.55, '게임': 0.35, '영상': 0.40, '일반': 0.80,
    };
    const ratio = specialtyRatios[conditions.specialty] || 0.50;
    current = Math.round(current * ratio);
    steps.push({ label: `${conditions.specialty} 분야`, count: current, total: TOTAL });
  }

  if (conditions.urgency !== 'normal') {
    current = Math.round(current * 0.53);
    const label = conditions.urgency === 'super-urgent' ? '초긴급 대응 가능' : '긴급 대응 가능';
    steps.push({ label, count: current, total: TOTAL });
  }

  if (conditions.certifications.length > 0) {
    const hasCert1 = conditions.certifications.includes('AITe 번역전문가 1급');
    const certRatio = hasCert1 ? 0.45 : 0.65;
    current = Math.round(current * certRatio);
    steps.push({ label: '자격 조건 충족', count: current, total: TOTAL });
  }

  if (conditions.minExperience > 0) {
    const expRatio = conditions.minExperience <= 1 ? 0.90 :
                     conditions.minExperience <= 3 ? 0.75 :
                     conditions.minExperience <= 5 ? 0.55 :
                     conditions.minExperience <= 10 ? 0.35 : 0.15;
    current = Math.round(current * expRatio);
    steps.push({ label: `경력 ${conditions.minExperience}년 이상`, count: current, total: TOTAL });
  }

  if (conditions.ndaRequired) {
    current = Math.round(current * 0.80);
    steps.push({ label: 'NDA 동의 가능', count: current, total: TOTAL });
  }

  return steps;
}
