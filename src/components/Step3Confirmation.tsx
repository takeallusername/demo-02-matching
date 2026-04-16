'use client';

import { motion } from 'framer-motion';
import { MatchConditions, MatchResult } from '@/data/types';

interface Props {
  conditions: MatchConditions;
  selectedExpert: MatchResult;
  onReset: () => void;
}

export default function Step3Confirmation({ conditions, selectedExpert, onReset }: Props) {
  const { expert, score } = selectedExpert;

  return (
    <div className="h-full flex items-center justify-center p-8">
      <motion.div
        initial={{ opacity: 0, scale: 0.95, y: 20 }}
        animate={{ opacity: 1, scale: 1, y: 0 }}
        transition={{ duration: 0.5, ease: 'easeOut' }}
        className="w-full max-w-2xl"
      >
        {/* Success Icon */}
        <motion.div
          initial={{ scale: 0 }}
          animate={{ scale: 1 }}
          transition={{ delay: 0.2, type: 'spring', stiffness: 200 }}
          className="text-center mb-6"
        >
          <div className="w-16 h-16 bg-success/10 rounded-full flex items-center justify-center mx-auto mb-3">
            <svg className="w-8 h-8 text-success" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
              <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
            </svg>
          </div>
          <h2 className="text-xl font-bold text-text-primary">매칭이 완료되었습니다</h2>
        </motion.div>

        {/* Matching Summary Card */}
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          className="bg-white rounded-xl border border-border p-6 mb-4"
        >
          <h3 className="text-[12px] font-semibold text-text-muted mb-4">매칭 요약</h3>

          <div className="grid grid-cols-3 gap-4 mb-5 text-[12px]">
            <div>
              <span className="text-text-muted block mb-0.5">방향</span>
              <span className="font-semibold">{conditions.sourceLang} → {conditions.targetLang}</span>
            </div>
            <div>
              <span className="text-text-muted block mb-0.5">분야</span>
              <span className="font-semibold">{conditions.specialty}{conditions.documentType ? ` (${conditions.documentType})` : ''}</span>
            </div>
            <div>
              <span className="text-text-muted block mb-0.5">긴급도</span>
              <span className={`font-semibold ${
                conditions.urgency === 'urgent' ? 'text-warning' :
                conditions.urgency === 'super-urgent' ? 'text-danger' : ''
              }`}>
                {conditions.urgency === 'normal' ? '일반 (3~5일)' :
                 conditions.urgency === 'urgent' ? '긴급 (1~2일)' : '초긴급 (당일)'}
              </span>
            </div>
          </div>

          <div className="h-px bg-border mb-5" />

          <div className="flex items-center gap-4">
            <div className="w-14 h-14 bg-accent/10 rounded-full flex items-center justify-center text-2xl shrink-0">
              👤
            </div>
            <div className="flex-1 min-w-0">
              <div className="text-[11px] text-text-muted mb-0.5">매칭된 전문가</div>
              <div className="text-[16px] font-bold text-text-primary">{expert.name}</div>
              <div className="text-[12px] text-text-secondary mt-0.5 flex flex-wrap gap-x-3 gap-y-0.5">
                <span>적합도: <span className="font-semibold text-accent">{score}%</span></span>
                <span>평점: ⭐ {expert.rating}</span>
                <span>{expert.specialties[0]} 경력 {expert.experienceYears}년</span>
                {expert.certifications[0] && <span>{expert.certifications[0].name}</span>}
                {conditions.documentType && (
                  <span>{conditions.documentType} 번역 {expert.documentExperience[conditions.documentType] || 0}건</span>
                )}
              </div>
            </div>
          </div>
        </motion.div>

        {/* Progress Timeline */}
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          className="bg-white rounded-xl border border-border p-5 mb-4"
        >
          <h3 className="text-[12px] font-semibold text-text-muted mb-4">진행 상태</h3>
          <div className="flex items-center justify-between text-[11px]">
            {[
              { label: '의뢰 등록', status: 'done' },
              { label: '매칭 완료', status: 'done' },
              { label: '번역 대기', status: 'current' },
              { label: '납품', status: 'pending' },
            ].map((step, i, arr) => (
              <div key={step.label} className="flex items-center">
                <div className="flex flex-col items-center gap-1">
                  <div className={`w-6 h-6 rounded-full flex items-center justify-center text-[10px] ${
                    step.status === 'done' ? 'bg-success text-white' :
                    step.status === 'current' ? 'bg-accent/20 text-accent border-2 border-accent' :
                    'bg-gray-200 text-gray-400'
                  }`}>
                    {step.status === 'done' ? (
                      <svg className="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={3}>
                        <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
                      </svg>
                    ) : step.status === 'current' ? '🔄' : '○'}
                  </div>
                  <span className={`font-medium ${
                    step.status === 'done' ? 'text-success' :
                    step.status === 'current' ? 'text-accent' :
                    'text-text-muted'
                  }`}>{step.label}</span>
                </div>
                {i < arr.length - 1 && (
                  <div className={`w-16 h-px mx-2 ${
                    step.status === 'done' ? 'bg-success' : 'bg-gray-200'
                  }`} />
                )}
              </div>
            ))}
          </div>
        </motion.div>

        {/* Next Actions */}
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
          className="bg-white rounded-xl border border-border p-5"
        >
          <h3 className="text-[12px] font-semibold text-text-muted mb-4">다음 단계</h3>
          <div className="flex gap-3">
            <button className="flex-1 h-11 bg-accent text-white text-[13px] font-semibold rounded-lg hover:bg-accent-hover transition-all shadow-sm flex items-center justify-center gap-2">
              <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
              </svg>
              전문가에게 메시지
            </button>
            <button
              onClick={onReset}
              className="flex-1 h-11 bg-white text-text-primary text-[13px] font-semibold rounded-lg border border-border hover:bg-gray-50 transition-all flex items-center justify-center gap-2"
            >
              <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
              새 의뢰 등록하기
            </button>
          </div>
        </motion.div>
      </motion.div>
    </div>
  );
}
