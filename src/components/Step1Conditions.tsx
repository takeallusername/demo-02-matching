'use client';

import { useEffect, useRef, useMemo } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { MatchConditions, SPECIALTIES, DOCUMENT_TYPES, LANGUAGES, CERTIFICATIONS, EXPERIENCE_OPTIONS, FunnelStep } from '@/data/types';
import { calculateFunnel } from '@/data/matching';

interface Props {
  conditions: MatchConditions;
  onChange: (conditions: MatchConditions) => void;
  onStartMatching: () => void;
}

function AnimatedCounter({ value }: { value: number }) {
  const ref = useRef<HTMLSpanElement>(null);
  const prevValue = useRef(value);

  useEffect(() => {
    const node = ref.current;
    if (!node) return;
    const start = prevValue.current;
    const end = value;
    const duration = 400;
    const startTime = performance.now();

    function tick(now: number) {
      const elapsed = now - startTime;
      const progress = Math.min(elapsed / duration, 1);
      const eased = 1 - Math.pow(1 - progress, 3);
      const current = Math.round(start + (end - start) * eased);
      node!.textContent = current.toLocaleString();
      if (progress < 1) requestAnimationFrame(tick);
    }

    requestAnimationFrame(tick);
    prevValue.current = value;
  }, [value]);

  return <span ref={ref}>{value.toLocaleString()}</span>;
}

function FunnelBar({ step, index }: { step: FunnelStep; index: number }) {
  const percentage = (step.count / step.total) * 100;

  return (
    <motion.div
      initial={{ opacity: 0, x: -10 }}
      animate={{ opacity: 1, x: 0 }}
      transition={{ delay: index * 0.05, duration: 0.3 }}
      className="flex items-center gap-3 text-[12px]"
    >
      <span className="w-[120px] text-text-secondary truncate text-right shrink-0">{step.label}</span>
      <div className="flex-1 h-5 bg-gray-100 rounded-sm overflow-hidden relative">
        <motion.div
          className="h-full rounded-sm"
          style={{
            background: `linear-gradient(90deg, #2563EB ${Math.max(percentage - 20, 0)}%, #3B82F6 100%)`,
          }}
          initial={{ width: '100%' }}
          animate={{ width: `${percentage}%` }}
          transition={{ duration: 0.5, ease: 'easeOut' }}
        />
      </div>
      <span className="w-[44px] text-right font-semibold text-text-primary tabular-nums shrink-0">
        <AnimatedCounter value={step.count} />명
      </span>
    </motion.div>
  );
}

export default function Step1Conditions({ conditions, onChange, onStartMatching }: Props) {
  const update = (partial: Partial<MatchConditions>) => {
    onChange({ ...conditions, ...partial });
  };

  const toggleCert = (cert: string) => {
    const certs = conditions.certifications.includes(cert)
      ? conditions.certifications.filter(c => c !== cert)
      : [...conditions.certifications, cert];
    update({ certifications: certs });
  };

  const funnel = useMemo(() => calculateFunnel(conditions), [conditions]);
  const matchCount = funnel[funnel.length - 1].count;
  const isReady = conditions.sourceLang && conditions.targetLang && conditions.specialty;

  return (
    <div className="flex flex-col h-full">
      <div className="flex-1 flex overflow-hidden">
        {/* Left: Form */}
        <div className="w-[60%] overflow-y-auto p-5 space-y-4">
          {/* Section 1: Basic Conditions */}
          <div className="bg-white rounded-xl border border-border p-5">
            <h3 className="text-[13px] font-bold text-text-primary mb-4 flex items-center gap-2">
              <span className="w-5 h-5 bg-accent/10 text-accent rounded flex items-center justify-center text-[10px] font-bold">1</span>
              기본 조건
            </h3>
            <div className="grid grid-cols-2 gap-4 mb-4">
              <div>
                <label className="block text-[11px] font-medium text-text-secondary mb-1.5">원본 언어</label>
                <select
                  value={conditions.sourceLang}
                  onChange={e => update({ sourceLang: e.target.value })}
                  className="w-full h-9 px-3 text-[13px] border border-border rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-accent/20 focus:border-accent transition-all"
                >
                  <option value="">선택하세요</option>
                  {LANGUAGES.map(lang => (
                    <option key={lang} value={lang}>{lang}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-[11px] font-medium text-text-secondary mb-1.5">번역 언어</label>
                <select
                  value={conditions.targetLang}
                  onChange={e => update({ targetLang: e.target.value })}
                  className="w-full h-9 px-3 text-[13px] border border-border rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-accent/20 focus:border-accent transition-all"
                >
                  <option value="">선택하세요</option>
                  {LANGUAGES.filter(l => l !== conditions.sourceLang).map(lang => (
                    <option key={lang} value={lang}>{lang}</option>
                  ))}
                </select>
              </div>
            </div>

            <div className="mb-4">
              <label className="block text-[11px] font-medium text-text-secondary mb-2">전문 분야</label>
              <div className="grid grid-cols-4 gap-2">
                {SPECIALTIES.map(spec => (
                  <button
                    key={spec}
                    onClick={() => update({ specialty: conditions.specialty === spec ? '' : spec })}
                    className={`h-8 text-[12px] font-medium rounded-lg border transition-all duration-200 ${
                      conditions.specialty === spec
                        ? 'bg-accent text-white border-accent shadow-sm'
                        : 'bg-white text-text-secondary border-border hover:border-accent/40 hover:text-accent'
                    }`}
                  >
                    {spec}
                  </button>
                ))}
              </div>
            </div>

            <div>
              <label className="block text-[11px] font-medium text-text-secondary mb-1.5">문서 유형</label>
              <select
                value={conditions.documentType}
                onChange={e => update({ documentType: e.target.value })}
                className="w-full h-9 px-3 text-[13px] border border-border rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-accent/20 focus:border-accent transition-all"
              >
                <option value="">선택하세요</option>
                {DOCUMENT_TYPES.map(dt => (
                  <option key={dt} value={dt}>{dt}</option>
                ))}
              </select>
            </div>
          </div>

          {/* Section 2: Project Details */}
          <div className="bg-white rounded-xl border border-border p-5">
            <h3 className="text-[13px] font-bold text-text-primary mb-4 flex items-center gap-2">
              <span className="w-5 h-5 bg-accent/10 text-accent rounded flex items-center justify-center text-[10px] font-bold">2</span>
              프로젝트 상세
            </h3>

            <div className="mb-4">
              <label className="block text-[11px] font-medium text-text-secondary mb-1.5">파일 업로드</label>
              <div className="border-2 border-dashed border-border rounded-lg p-4 text-center hover:border-accent/40 transition-colors cursor-pointer">
                <div className="text-text-muted text-[12px]">
                  <svg className="w-6 h-6 mx-auto mb-1 text-text-muted" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                  </svg>
                  드래그 앤 드롭 또는 파일 선택
                </div>
                <div className="mt-2 flex items-center justify-center gap-2 text-[11px] text-accent">
                  <svg className="w-3.5 h-3.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                  </svg>
                  계약서_v3.docx &nbsp;<span className="text-text-muted">12KB</span>
                </div>
              </div>
            </div>

            <div className="mb-4">
              <label className="block text-[11px] font-medium text-text-secondary mb-2">긴급도</label>
              <div className="flex gap-2">
                {[
                  { value: 'normal' as const, label: '일반', sub: '3~5일', color: 'text-text-secondary border-border' },
                  { value: 'urgent' as const, label: '긴급', sub: '1~2일', color: 'text-warning border-warning/30' },
                  { value: 'super-urgent' as const, label: '초긴급', sub: '당일', color: 'text-danger border-danger/30' },
                ].map(opt => (
                  <button
                    key={opt.value}
                    onClick={() => update({ urgency: opt.value })}
                    className={`flex-1 h-10 text-[12px] font-medium rounded-lg border transition-all duration-200 ${
                      conditions.urgency === opt.value
                        ? opt.value === 'normal'
                          ? 'bg-accent text-white border-accent'
                          : opt.value === 'urgent'
                          ? 'bg-warning text-white border-warning'
                          : 'bg-danger text-white border-danger'
                        : `bg-white ${opt.color} hover:bg-gray-50`
                    }`}
                  >
                    {opt.label} <span className="text-[10px] opacity-70">({opt.sub})</span>
                  </button>
                ))}
              </div>
            </div>

            <div>
              <label className="block text-[11px] font-medium text-text-secondary mb-1.5">요청사항</label>
              <textarea
                value={conditions.notes}
                onChange={e => update({ notes: e.target.value })}
                placeholder="예: 법률 전문 용어에 주의해주세요."
                className="w-full h-16 px-3 py-2 text-[12px] border border-border rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-accent/20 focus:border-accent transition-all resize-none"
              />
            </div>
          </div>

          {/* Section 3: Expert Requirements */}
          <div className="bg-white rounded-xl border border-border p-5">
            <h3 className="text-[13px] font-bold text-text-primary mb-1 flex items-center gap-2">
              <span className="w-5 h-5 bg-accent/10 text-accent rounded flex items-center justify-center text-[10px] font-bold">3</span>
              전문가 조건
              <span className="text-[10px] font-normal text-text-muted">(선택)</span>
            </h3>
            <p className="text-[11px] text-text-muted mb-4">조건을 추가할수록 더 정확한 매칭이 가능합니다.</p>

            <div className="mb-4">
              <label className="block text-[11px] font-medium text-text-secondary mb-2">필수 자격</label>
              <div className="space-y-1.5">
                {CERTIFICATIONS.map(cert => (
                  <label key={cert} className="flex items-center gap-2 cursor-pointer group">
                    <div
                      className={`w-4 h-4 rounded border flex items-center justify-center transition-all ${
                        conditions.certifications.includes(cert)
                          ? 'bg-accent border-accent'
                          : 'border-border group-hover:border-accent/40'
                      }`}
                      onClick={() => toggleCert(cert)}
                    >
                      {conditions.certifications.includes(cert) && (
                        <svg className="w-2.5 h-2.5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={3}>
                          <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
                        </svg>
                      )}
                    </div>
                    <span className="text-[12px] text-text-primary" onClick={() => toggleCert(cert)}>{cert}</span>
                  </label>
                ))}
              </div>
            </div>

            <div className="mb-4">
              <label className="block text-[11px] font-medium text-text-secondary mb-1.5">최소 경력</label>
              <select
                value={conditions.minExperience}
                onChange={e => update({ minExperience: Number(e.target.value) })}
                className="w-full h-9 px-3 text-[13px] border border-border rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-accent/20 focus:border-accent transition-all"
              >
                <option value={0}>무관</option>
                {EXPERIENCE_OPTIONS.filter(e => e > 0).map(exp => (
                  <option key={exp} value={exp}>{exp}년 이상</option>
                ))}
              </select>
            </div>

            <div className="space-y-1.5">
              <label className="flex items-center gap-2 cursor-pointer group">
                <div
                  className={`w-4 h-4 rounded border flex items-center justify-center transition-all ${
                    conditions.preferNative
                      ? 'bg-accent border-accent'
                      : 'border-border group-hover:border-accent/40'
                  }`}
                  onClick={() => update({ preferNative: !conditions.preferNative })}
                >
                  {conditions.preferNative && (
                    <svg className="w-2.5 h-2.5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={3}>
                      <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
                    </svg>
                  )}
                </div>
                <span className="text-[12px] text-text-primary" onClick={() => update({ preferNative: !conditions.preferNative })}>원어민 번역사 우선</span>
              </label>
              <label className="flex items-center gap-2 cursor-pointer group">
                <div
                  className={`w-4 h-4 rounded border flex items-center justify-center transition-all ${
                    conditions.ndaRequired
                      ? 'bg-accent border-accent'
                      : 'border-border group-hover:border-accent/40'
                  }`}
                  onClick={() => update({ ndaRequired: !conditions.ndaRequired })}
                >
                  {conditions.ndaRequired && (
                    <svg className="w-2.5 h-2.5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={3}>
                      <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
                    </svg>
                  )}
                </div>
                <span className="text-[12px] text-text-primary" onClick={() => update({ ndaRequired: !conditions.ndaRequired })}>NDA 동의 가능자</span>
              </label>
            </div>
          </div>
        </div>

        {/* Right: Real-time Preview */}
        <div className="w-[40%] p-5 overflow-y-auto">
          <div className="bg-white rounded-xl border border-border p-6 sticky top-0">
            <h3 className="text-[12px] font-medium text-text-secondary text-center mb-2">
              현재 조건으로 매칭 가능한 전문가
            </h3>

            <div className="text-center py-4">
              <motion.div
                key={matchCount}
                initial={{ scale: 1.1 }}
                animate={{ scale: 1 }}
                transition={{ type: 'spring', stiffness: 300, damping: 20 }}
              >
                <span className="text-5xl font-bold text-accent tabular-nums">
                  <AnimatedCounter value={matchCount} />
                </span>
                <span className="text-lg text-text-secondary ml-1">명</span>
              </motion.div>
            </div>

            <div className="h-px bg-border my-4" />

            <h4 className="text-[11px] font-medium text-text-muted mb-3">필터 현황</h4>

            <div className="space-y-2.5">
              <AnimatePresence mode="popLayout">
                {funnel.map((step, i) => (
                  <FunnelBar key={step.label} step={step} index={i} />
                ))}
              </AnimatePresence>
            </div>

            {matchCount === 0 && (
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                className="mt-4 p-3 bg-danger/5 border border-danger/20 rounded-lg text-[11px] text-danger text-center"
              >
                조건에 맞는 전문가가 없습니다. 조건을 완화해주세요.
              </motion.div>
            )}

            {matchCount > 0 && funnel.length <= 2 && (
              <div className="mt-4 p-3 bg-accent-light/50 rounded-lg text-[11px] text-accent text-center">
                조건을 추가하면 더 정확한 매칭이 가능합니다.
              </div>
            )}

            {matchCount > 0 && funnel.length > 2 && matchCount <= 10 && (
              <div className="mt-4 p-3 bg-warning-light/50 rounded-lg text-[11px] text-warning text-center">
                매칭 가능 인원이 적습니다. 조건을 완화하면 더 많은 전문가를 비교할 수 있습니다.
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Bottom Bar */}
      <div className="shrink-0 bg-white border-t border-border px-6 py-3 flex items-center justify-between">
        <div className="text-[13px] text-text-secondary">
          매칭 가능: <span className="font-bold text-accent">{matchCount}명</span>
        </div>
        <button
          onClick={onStartMatching}
          disabled={!isReady || matchCount === 0}
          className={`h-10 px-8 rounded-lg text-[13px] font-semibold transition-all duration-200 flex items-center gap-2 ${
            isReady && matchCount > 0
              ? 'bg-accent text-white hover:bg-accent-hover shadow-sm hover:shadow-md active:scale-[0.98]'
              : 'bg-gray-100 text-text-muted cursor-not-allowed'
          }`}
        >
          AI 매칭 시작
          <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
            <path strokeLinecap="round" strokeLinejoin="round" d="M13 7l5 5m0 0l-5 5m5-5H6" />
          </svg>
        </button>
      </div>
    </div>
  );
}
