export const SPECIALTIES = ['법률', '의료', 'IT', '금융', '마케팅', '게임', '영상', '일반'] as const;
export const DOCUMENT_TYPES = ['계약서', '매뉴얼', '마케팅자료', '자막', '논문', '특허', '기타'] as const;
export const LANGUAGES = ['한국어', '영어', '일본어', '중국어'] as const;
export const CERTIFICATIONS = ['AITe 번역전문가 1급', 'AITe 번역전문가 2급', 'ITT 통번역 자격'] as const;
export const EXPERIENCE_OPTIONS = [0, 1, 3, 5, 10] as const;

export interface Expert {
  id: string;
  name: string;
  nameEn: string;
  rating: number;
  completedProjects: number;
  specialties: string[];
  languages: { from: string; to: string }[];
  experienceYears: number;
  specialtyExperience: Record<string, number>;
  certifications: { name: string; year: number }[];
  tools: string[];
  bio: string;
  urgentAvailable: boolean;
  onTimeRate: number;
  ndaAvailable: boolean;
  isNative: boolean;
  documentExperience: Record<string, number>;
  recentProjects: { name: string; field: string; langPair: string; rating: number; date: string }[];
}

export interface MatchConditions {
  sourceLang: string;
  targetLang: string;
  specialty: string;
  documentType: string;
  urgency: 'normal' | 'urgent' | 'super-urgent';
  certifications: string[];
  minExperience: number;
  preferNative: boolean;
  ndaRequired: boolean;
  notes: string;
}

export interface ScoreBreakdown {
  fieldMatch: number;
  qualification: number;
  experience: number;
  performance: number;
  urgency: number;
}

export interface MatchReason {
  text: string;
  met: boolean;
}

export interface MatchResult {
  expert: Expert;
  score: number;
  breakdown: ScoreBreakdown;
  reasons: MatchReason[];
  aiSummary: string;
}

export interface FunnelStep {
  label: string;
  count: number;
  total: number;
}
