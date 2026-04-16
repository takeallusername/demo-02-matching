'use client';

import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { MatchConditions, MatchResult } from '@/data/types';

interface Props {
  conditions: MatchConditions;
  results: MatchResult[];
  selectedExpert: MatchResult | null;
  onSelectExpert: (result: MatchResult) => void;
  onConfirm: () => void;
  onBack: () => void;
}

type ViewMode = 'card' | 'compare';
type DetailTab = 'profile' | 'analysis';

const RANK_LABELS = ['1순위 추천', '2순위 추천', '3순위 추천'];
const RANK_ICONS = ['🥇', '🥈', '🥉'];
const RANK_BORDERS = [
  'border-yellow-400/60 shadow-yellow-400/10',
  'border-gray-300/60 shadow-gray-300/10',
  'border-orange-400/40 shadow-orange-400/10',
];

function ScoreBar({ score, color = 'bg-accent' }: { score: number; color?: string }) {
  return (
    <div className="h-1.5 bg-gray-100 rounded-full overflow-hidden">
      <motion.div
        className={`h-full rounded-full ${color}`}
        initial={{ width: 0 }}
        animate={{ width: `${score}%` }}
        transition={{ duration: 0.6, ease: 'easeOut' }}
      />
    </div>
  );
}

function ExpertCard({
  result, rank, isSelected, onSelect, onDetail,
}: {
  result: MatchResult;
  rank: number;
  isSelected: boolean;
  onSelect: () => void;
  onDetail: () => void;
}) {
  const { expert, score, reasons } = result;

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: rank * 0.1, duration: 0.4 }}
      whileHover={{ y: -2 }}
      className={`bg-white rounded-xl border-2 transition-all duration-200 overflow-hidden ${
        isSelected
          ? 'border-success shadow-lg shadow-success/10'
          : `${RANK_BORDERS[rank]} shadow-md hover:shadow-lg`
      } ${rank === 0 ? 'scale-[1.02]' : ''}`}
    >
      {/* Header */}
      <div className={`px-4 py-2.5 flex items-center justify-between ${
        rank === 0 ? 'bg-gradient-to-r from-yellow-50 to-amber-50' :
        rank === 1 ? 'bg-gray-50' : 'bg-orange-50/50'
      }`}>
        <div className="flex items-center gap-2">
          <span className="text-base">{RANK_ICONS[rank]}</span>
          <span className="text-[11px] font-semibold text-text-secondary">{RANK_LABELS[rank]}</span>
        </div>
        <div className="flex items-center gap-2">
          <span className="text-[18px] font-bold text-accent tabular-nums">{score}%</span>
        </div>
      </div>
      <div className="px-4 pt-0.5 pb-0">
        <ScoreBar score={score} />
      </div>

      {/* Profile */}
      <div className="px-4 py-3">
        <div className="flex items-center gap-3 mb-2">
          <div className="w-10 h-10 bg-accent/10 rounded-full flex items-center justify-center text-lg shrink-0">
            👤
          </div>
          <div className="min-w-0">
            <div className="text-[14px] font-bold text-text-primary truncate">{expert.name}</div>
            <div className="text-[11px] text-text-secondary">
              ⭐ {expert.rating} / 5.0 &nbsp;({expert.completedProjects}건 완료)
            </div>
          </div>
        </div>
        <div className="text-[11px] text-text-secondary">
          {expert.specialties.join(' · ')} 경력 {expert.experienceYears}년
          {expert.certifications.length > 0 && ` · ${expert.certifications[0].name}`}
        </div>
      </div>

      {/* Match Reasons */}
      <div className="px-4 pb-3 border-t border-border/60">
        <div className="text-[11px] font-semibold text-text-secondary mt-2.5 mb-2 flex items-center gap-1">
          📌 매칭 이유
        </div>
        <div className="space-y-1">
          {reasons.map((reason, i) => (
            <div key={i} className="flex items-start gap-1.5 text-[11px]">
              <span className={reason.met ? 'text-success' : 'text-warning'}>
                {reason.met ? '✅' : '⚠️'}
              </span>
              <span className={reason.met ? 'text-text-primary' : 'text-warning'}>{reason.text}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Actions */}
      <div className="px-4 py-2.5 bg-gray-50/50 border-t border-border/60 flex items-center gap-2">
        <button
          onClick={onDetail}
          className="flex-1 h-8 text-[11px] font-medium text-text-secondary border border-border rounded-lg hover:bg-white hover:border-accent/30 hover:text-accent transition-all"
        >
          상세 보기
        </button>
        <button
          onClick={onSelect}
          className={`flex-1 h-8 text-[11px] font-semibold rounded-lg transition-all ${
            isSelected
              ? 'bg-success text-white'
              : 'bg-accent text-white hover:bg-accent-hover'
          }`}
        >
          {isSelected ? '✓ 선택됨' : '이 전문가 선택'}
        </button>
      </div>
    </motion.div>
  );
}

function ComparisonTable({
  results, conditions, selectedId, onSelect,
}: {
  results: MatchResult[];
  conditions: MatchConditions;
  selectedId: string | null;
  onSelect: (result: MatchResult) => void;
}) {
  const rows = [
    {
      label: '적합도',
      values: results.map(r => r.score),
      render: (v: number) => (
        <div className="flex items-center gap-2">
          <span className="font-bold tabular-nums">{v}%</span>
          <div className="flex-1 h-1.5 bg-gray-100 rounded-full overflow-hidden">
            <div className="h-full bg-accent rounded-full" style={{ width: `${v}%` }} />
          </div>
        </div>
      ),
      best: (vals: number[]) => Math.max(...vals),
    },
    {
      label: '평점',
      values: results.map(r => r.expert.rating),
      render: (v: number) => <span>⭐ {v}</span>,
      best: (vals: number[]) => Math.max(...vals),
    },
    {
      label: '완료 건수',
      values: results.map(r => r.expert.completedProjects),
      render: (v: number) => <span>{v}건</span>,
      best: (vals: number[]) => Math.max(...vals),
    },
    ...(conditions.specialty ? [{
      label: `${conditions.specialty} 경력`,
      values: results.map(r => r.expert.specialtyExperience[conditions.specialty] || 0),
      render: (v: number) => <span>{v}년</span>,
      best: (vals: number[]) => Math.max(...vals),
    }] : []),
    ...(conditions.documentType ? [{
      label: `${conditions.documentType} 경험`,
      values: results.map(r => r.expert.documentExperience[conditions.documentType] || 0),
      render: (v: number) => <span>{v}건</span>,
      best: (vals: number[]) => Math.max(...vals),
    }] : []),
    {
      label: '자격증',
      values: results.map(r => {
        if (conditions.certifications.length === 0) return r.expert.certifications.map(c => c.name).join(', ') || '없음';
        const hasCert = conditions.certifications.every(rc =>
          r.expert.certifications.some(c => c.name === rc)
        );
        return { text: r.expert.certifications.map(c => c.name).join(', ') || '없음', met: hasCert };
      }),
      render: (v: unknown) => {
        if (typeof v === 'string') return <span className="text-[11px]">{v}</span>;
        const val = v as { text: string; met: boolean };
        return (
          <span className={`text-[11px] ${val.met ? '' : 'text-warning'}`}>
            {val.text} {val.met ? '✅' : '⚠️'}
          </span>
        );
      },
      best: () => null,
    },
    {
      label: '납기 준수율',
      values: results.map(r => r.expert.onTimeRate),
      render: (v: number) => <span>{v}%</span>,
      best: (vals: number[]) => Math.max(...vals),
    },
    ...(conditions.urgency !== 'normal' ? [{
      label: '긴급 대응',
      values: results.map(r => r.expert.urgentAvailable),
      render: (v: boolean) => (
        <span className={v ? 'text-success' : 'text-warning'}>
          {v ? '가능 ✅' : '불가 ⚠️'}
        </span>
      ),
      best: () => null,
    }] : []),
  ];

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ duration: 0.3 }}
      className="bg-white rounded-xl border border-border overflow-hidden"
    >
      <table className="w-full text-[12px]">
        <thead>
          <tr className="border-b border-border bg-gray-50">
            <th className="text-left py-2.5 px-4 font-semibold text-text-secondary w-[140px]">항목</th>
            {results.map((r, i) => (
              <th key={r.expert.id} className="text-left py-2.5 px-4 font-semibold">
                <span className="mr-1">{RANK_ICONS[i]}</span> {r.expert.name}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((row, ri) => (
            <tr key={ri} className="border-b border-border/50 last:border-0">
              <td className="py-2 px-4 text-text-secondary font-medium">{row.label}</td>
              {row.values.map((v, ci) => {
                const bestVal = typeof row.best === 'function' ? row.best(row.values as number[]) : null;
                const isBest = bestVal !== null && v === bestVal;
                return (
                  <td
                    key={ci}
                    className={`py-2 px-4 ${isBest ? 'font-bold text-accent bg-accent/5' : ''} ${
                      typeof v === 'object' && v !== null && 'met' in (v as Record<string, unknown>) && !(v as { met: boolean }).met
                        ? 'bg-warning/5'
                        : ''
                    }`}
                  >
                    {row.render(v as never)}
                  </td>
                );
              })}
            </tr>
          ))}
          <tr className="bg-gray-50">
            <td className="py-2.5 px-4" />
            {results.map(r => (
              <td key={r.expert.id} className="py-2.5 px-4">
                <button
                  onClick={() => onSelect(r)}
                  className={`h-7 px-4 text-[11px] font-semibold rounded-lg transition-all ${
                    selectedId === r.expert.id
                      ? 'bg-success text-white'
                      : 'bg-accent text-white hover:bg-accent-hover'
                  }`}
                >
                  {selectedId === r.expert.id ? '✓ 선택됨' : '선택'}
                </button>
              </td>
            ))}
          </tr>
        </tbody>
      </table>
    </motion.div>
  );
}

function ExpertDetail({ result, conditions }: { result: MatchResult; conditions: MatchConditions }) {
  const [tab, setTab] = useState<DetailTab>('profile');
  const { expert, breakdown, aiSummary, score } = result;

  const breakdownItems = [
    { label: '분야 적합성', weight: 30, score: breakdown.fieldMatch },
    { label: '자격 보유', weight: 25, score: breakdown.qualification },
    { label: '경력', weight: 20, score: breakdown.experience },
    { label: '과거 실적', weight: 15, score: breakdown.performance },
    { label: '긴급 대응', weight: 10, score: breakdown.urgency },
  ];

  const totalFieldProjects = Object.entries(expert.documentExperience).reduce((sum, [, v]) => sum + v, 0);
  const fieldBreakdown = expert.specialties.map(s => ({
    name: s,
    count: expert.recentProjects.filter(p => p.field === s).length * Math.ceil(totalFieldProjects / 5),
  }));

  return (
    <motion.div
      initial={{ opacity: 0, y: 20, height: 0 }}
      animate={{ opacity: 1, y: 0, height: 'auto' }}
      exit={{ opacity: 0, y: 20, height: 0 }}
      transition={{ duration: 0.3 }}
      className="bg-white rounded-xl border border-border overflow-hidden"
    >
      {/* Tabs */}
      <div className="flex border-b border-border">
        {[
          { id: 'profile' as const, label: '프로필 & 이력' },
          { id: 'analysis' as const, label: 'AI 매칭 분석' },
        ].map(t => (
          <button
            key={t.id}
            onClick={() => setTab(t.id)}
            className={`flex-1 py-2.5 text-[12px] font-medium transition-all relative ${
              tab === t.id ? 'text-accent' : 'text-text-secondary hover:text-text-primary'
            }`}
          >
            {t.label}
            {tab === t.id && (
              <motion.div layoutId="detail-tab" className="absolute bottom-0 left-0 right-0 h-0.5 bg-accent" />
            )}
          </button>
        ))}
      </div>

      <div className="p-5">
        <AnimatePresence mode="wait">
          {tab === 'profile' ? (
            <motion.div
              key="profile"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              className="grid grid-cols-2 gap-5"
            >
              {/* Profile Section */}
              <div>
                <div className="flex items-center gap-3 mb-3">
                  <div className="w-12 h-12 bg-accent/10 rounded-full flex items-center justify-center text-2xl">👤</div>
                  <div>
                    <div className="text-[15px] font-bold">{expert.name} <span className="text-[11px] font-normal text-text-muted">({expert.nameEn})</span></div>
                  </div>
                </div>

                <div className="space-y-2 text-[12px]">
                  <div className="flex gap-2">
                    <span className="text-text-muted w-[70px] shrink-0">전문 분야:</span>
                    <span className="font-medium">{expert.specialties.join(', ')}</span>
                  </div>
                  <div className="flex gap-2">
                    <span className="text-text-muted w-[70px] shrink-0">가능 언어:</span>
                    <span className="font-medium">{expert.languages.map(l => `${l.from}→${l.to}`).join(', ')}</span>
                  </div>
                  <div className="flex gap-2">
                    <span className="text-text-muted w-[70px] shrink-0">경력:</span>
                    <span className="font-medium">{expert.experienceYears}년 ({expert.specialties[0]} 전문)</span>
                  </div>
                  {expert.certifications.length > 0 && (
                    <div className="flex gap-2">
                      <span className="text-text-muted w-[70px] shrink-0">보유 자격:</span>
                      <div className="space-y-0.5">
                        {expert.certifications.map(c => (
                          <div key={c.name} className="font-medium">🏅 {c.name} ({c.year})</div>
                        ))}
                      </div>
                    </div>
                  )}
                  <div className="flex gap-2">
                    <span className="text-text-muted w-[70px] shrink-0">사용 도구:</span>
                    <span className="font-medium">{expert.tools.join(', ')}</span>
                  </div>
                </div>

                <p className="text-[11px] text-text-secondary mt-3 leading-relaxed bg-surface-alt rounded-lg p-3">
                  {expert.bio}
                </p>
              </div>

              {/* Recent Work Section */}
              <div>
                <h4 className="text-[12px] font-bold text-text-primary mb-3">최근 작업</h4>
                <table className="w-full text-[11px]">
                  <thead>
                    <tr className="text-text-muted border-b border-border">
                      <th className="text-left pb-1.5 font-medium">프로젝트</th>
                      <th className="text-left pb-1.5 font-medium">분야</th>
                      <th className="text-left pb-1.5 font-medium">언어</th>
                      <th className="text-left pb-1.5 font-medium">평점</th>
                      <th className="text-left pb-1.5 font-medium">날짜</th>
                    </tr>
                  </thead>
                  <tbody>
                    {expert.recentProjects.map((p, i) => (
                      <tr key={i} className="border-b border-border/30">
                        <td className="py-1.5 font-medium">{p.name}</td>
                        <td className="py-1.5 text-text-secondary">{p.field}</td>
                        <td className="py-1.5 text-text-secondary">{p.langPair}</td>
                        <td className="py-1.5">⭐{p.rating}</td>
                        <td className="py-1.5 text-text-muted">{p.date}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
                <div className="mt-2 text-[10px] text-text-muted">
                  총 {expert.completedProjects}건 · 평균 ⭐{expert.rating} ·{' '}
                  {fieldBreakdown.map(f => `${f.name} ${f.count}건`).join(' / ')}
                </div>
              </div>
            </motion.div>
          ) : (
            <motion.div
              key="analysis"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
            >
              <h4 className="text-[12px] font-bold text-text-primary mb-4">AI 매칭 분석</h4>
              <div className="space-y-3 mb-5">
                {breakdownItems.map((item, i) => (
                  <div key={i} className="flex items-center gap-3">
                    <span className="text-[11px] text-text-secondary w-[120px] shrink-0">
                      {item.label} <span className="text-text-muted">(가중치 {item.weight}%)</span>
                    </span>
                    <div className="flex-1 h-4 bg-gray-100 rounded-full overflow-hidden relative">
                      <motion.div
                        className="h-full rounded-full bg-gradient-to-r from-accent to-blue-400"
                        initial={{ width: 0 }}
                        animate={{ width: `${item.score}%` }}
                        transition={{ delay: i * 0.1, duration: 0.5, ease: 'easeOut' }}
                      />
                    </div>
                    <span className="text-[12px] font-bold text-text-primary w-[40px] text-right tabular-nums">
                      {item.score}점
                    </span>
                  </div>
                ))}
              </div>

              <div className="flex items-center gap-3 mb-4 py-2 border-t border-border">
                <span className="text-[12px] font-bold text-text-primary w-[120px]">종합 적합도</span>
                <div className="flex-1" />
                <span className="text-xl font-bold text-accent tabular-nums">{score}점</span>
              </div>

              <div className="bg-accent/5 border border-accent/10 rounded-xl p-4">
                <h5 className="text-[11px] font-semibold text-accent mb-2">AI 추천 요약</h5>
                <p className="text-[12px] text-text-primary leading-relaxed">
                  &ldquo;{aiSummary}&rdquo;
                </p>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </motion.div>
  );
}

export default function Step2Comparison({
  conditions, results, selectedExpert, onSelectExpert, onConfirm, onBack,
}: Props) {
  const [viewMode, setViewMode] = useState<ViewMode>('card');
  const [detailExpert, setDetailExpert] = useState<MatchResult | null>(null);

  const conditionTags = [
    conditions.sourceLang && conditions.targetLang && `🌐 ${conditions.sourceLang}→${conditions.targetLang}`,
    conditions.specialty && `📋 ${conditions.specialty}${conditions.documentType ? ` (${conditions.documentType})` : ''}`,
    conditions.urgency === 'urgent' && '⚡ 긴급',
    conditions.urgency === 'super-urgent' && '🔥 초긴급',
    ...conditions.certifications.map(c => `🏅 ${c}`),
    conditions.minExperience > 0 && `📅 ${conditions.minExperience}년+`,
  ].filter(Boolean);

  return (
    <div className="flex flex-col h-full">
      {/* Project Summary Bar */}
      <div className="shrink-0 bg-white border-b border-border px-5 py-2 flex items-center gap-2 overflow-x-auto">
        {conditionTags.map((tag, i) => (
          <span key={i} className="inline-flex items-center px-2.5 py-1 bg-surface-alt text-[11px] font-medium text-text-secondary rounded-md whitespace-nowrap">
            {tag}
          </span>
        ))}
        <div className="ml-auto shrink-0">
          <button
            onClick={onBack}
            className="text-[11px] text-text-muted hover:text-accent transition-colors flex items-center gap-1"
          >
            <svg className="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
              <path strokeLinecap="round" strokeLinejoin="round" d="M15 19l-7-7 7-7" />
            </svg>
            조건 수정
          </button>
        </div>
      </div>

      {/* Main Content */}
      <div className="flex-1 overflow-y-auto p-5 space-y-4">
        {/* View Toggle */}
        <div className="flex items-center gap-1 bg-gray-100 rounded-lg p-0.5 w-fit">
          {[
            { id: 'card' as const, label: '카드 뷰' },
            { id: 'compare' as const, label: '비교 뷰' },
          ].map(v => (
            <button
              key={v.id}
              onClick={() => setViewMode(v.id)}
              className={`px-4 py-1.5 text-[11px] font-medium rounded-md transition-all ${
                viewMode === v.id
                  ? 'bg-white text-text-primary shadow-sm'
                  : 'text-text-muted hover:text-text-secondary'
              }`}
            >
              {v.label}
            </button>
          ))}
        </div>

        {/* Cards / Table */}
        <AnimatePresence mode="wait">
          {viewMode === 'card' ? (
            <motion.div
              key="cards"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              className="grid grid-cols-3 gap-4"
            >
              {results.map((result, i) => (
                <ExpertCard
                  key={result.expert.id}
                  result={result}
                  rank={i}
                  isSelected={selectedExpert?.expert.id === result.expert.id}
                  onSelect={() => onSelectExpert(result)}
                  onDetail={() => setDetailExpert(detailExpert?.expert.id === result.expert.id ? null : result)}
                />
              ))}
            </motion.div>
          ) : (
            <ComparisonTable
              key="table"
              results={results}
              conditions={conditions}
              selectedId={selectedExpert?.expert.id || null}
              onSelect={onSelectExpert}
            />
          )}
        </AnimatePresence>

        {/* Detail Panel */}
        <AnimatePresence>
          {detailExpert && (
            <ExpertDetail result={detailExpert} conditions={conditions} />
          )}
        </AnimatePresence>
      </div>

      {/* Bottom Bar */}
      <div className="shrink-0 bg-white border-t border-border px-6 py-3 flex items-center justify-between">
        <div className="text-[13px] text-text-secondary">
          {selectedExpert ? (
            <>
              선택된 전문가: <span className="font-bold text-text-primary">{selectedExpert.expert.name}</span>
              <span className="text-accent ml-1">(적합도 {selectedExpert.score}%)</span>
            </>
          ) : (
            <span className="text-text-muted">전문가를 선택해주세요</span>
          )}
        </div>
        <button
          onClick={onConfirm}
          disabled={!selectedExpert}
          className={`h-10 px-8 rounded-lg text-[13px] font-semibold transition-all duration-200 flex items-center gap-2 ${
            selectedExpert
              ? 'bg-accent text-white hover:bg-accent-hover shadow-sm hover:shadow-md active:scale-[0.98]'
              : 'bg-gray-100 text-text-muted cursor-not-allowed'
          }`}
        >
          매칭 확정
          <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
            <path strokeLinecap="round" strokeLinejoin="round" d="M13 7l5 5m0 0l-5 5m5-5H6" />
          </svg>
        </button>
      </div>
    </div>
  );
}
