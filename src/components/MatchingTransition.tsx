'use client';

import { useState, useEffect, useRef, useMemo } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { MatchResult } from '@/data/types';

interface Props {
  results: MatchResult[];
  onComplete: () => void;
  matchCount: number;
}

function ScoreCounter({ target, delay }: { target: number; delay: number }) {
  const ref = useRef<HTMLSpanElement>(null);
  const [started, setStarted] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => setStarted(true), delay);
    return () => clearTimeout(timer);
  }, [delay]);

  useEffect(() => {
    if (!started || !ref.current) return;
    const node = ref.current;
    const duration = 1200;
    const startTime = performance.now();

    function tick(now: number) {
      const elapsed = now - startTime;
      const progress = Math.min(elapsed / duration, 1);
      const eased = 1 - Math.pow(1 - progress, 4);
      node!.textContent = `${Math.round(target * eased)}%`;
      if (progress < 1) requestAnimationFrame(tick);
    }

    requestAnimationFrame(tick);
  }, [started, target]);

  return <span ref={ref} className="tabular-nums">0%</span>;
}

function useParticles(count: number) {
  return useMemo(() =>
    Array.from({ length: count }).map(() => ({
      x: Math.random() * 1200,
      y: Math.random() * 800,
      drift: Math.random() * -200,
      duration: 3 + Math.random() * 2,
      delay: Math.random() * 2,
    })),
  [count]);
}

const RANK_BADGES = ['🥇', '🥈', '🥉', '', ''];
const RANK_COLORS = [
  'from-yellow-400/20 to-yellow-500/10 border-yellow-400/40',
  'from-gray-300/20 to-gray-400/10 border-gray-400/30',
  'from-orange-300/20 to-orange-400/10 border-orange-400/30',
  'from-gray-100 to-gray-50 border-gray-200',
  'from-gray-100 to-gray-50 border-gray-200',
];

export default function MatchingTransition({ results, onComplete, matchCount }: Props) {
  const [phase, setPhase] = useState<1 | 2>(1);

  useEffect(() => {
    const t1 = setTimeout(() => setPhase(2), 2800);
    const t2 = setTimeout(() => onComplete(), 4200);
    return () => { clearTimeout(t1); clearTimeout(t2); };
  }, [onComplete]);

  const top5 = results.slice(0, 5);
  const top3 = results.slice(0, 3);
  const particles = useParticles(20);

  return (
    <div className="h-full flex flex-col items-center justify-center bg-gradient-to-b from-navy-900 to-navy-800 relative overflow-hidden">
      {/* Background particles */}
      <div className="absolute inset-0 overflow-hidden">
        {particles.map((p, i) => (
          <motion.div
            key={i}
            className="absolute w-1 h-1 bg-accent/30 rounded-full"
            initial={{ x: p.x, y: p.y }}
            animate={{ y: [null, p.drift], opacity: [0.3, 0] }}
            transition={{ duration: p.duration, repeat: Infinity, delay: p.delay }}
          />
        ))}
      </div>

      <AnimatePresence mode="wait">
        {phase === 1 ? (
          <motion.div
            key="phase1"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0, y: -30 }}
            transition={{ duration: 0.4 }}
            className="text-center z-10"
          >
            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2 }}
              className="mb-8"
            >
              <div className="text-[14px] text-gray-400 mb-2">
                {matchCount}명의 후보 중 적합도를 분석하고 있습니다...
              </div>
              <motion.div
                className="h-0.5 bg-accent/20 rounded-full w-64 mx-auto overflow-hidden"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
              >
                <motion.div
                  className="h-full bg-accent rounded-full"
                  initial={{ width: '0%' }}
                  animate={{ width: '100%' }}
                  transition={{ duration: 2.5, ease: 'easeInOut' }}
                />
              </motion.div>
            </motion.div>

            <div className="flex items-end justify-center gap-4">
              {top5.map((result, i) => (
                <motion.div
                  key={result.expert.id}
                  initial={{ opacity: 0, y: 40, scale: 0.85 }}
                  animate={{ opacity: 1, y: 0, scale: 1 }}
                  transition={{ delay: 0.4 + i * 0.15, duration: 0.4, ease: 'easeOut' }}
                  className={`w-28 bg-gradient-to-b ${RANK_COLORS[i]} border rounded-xl p-4 text-center backdrop-blur-sm`}
                >
                  <div className="w-10 h-10 bg-gray-700/50 rounded-full mx-auto mb-2 flex items-center justify-center text-lg">
                    👤
                  </div>
                  <div className="text-xl font-bold text-white mb-1">
                    <ScoreCounter target={result.score} delay={600 + i * 150} />
                  </div>
                  <div className="text-[11px] text-gray-300 truncate">{result.expert.name}</div>
                </motion.div>
              ))}
            </div>
          </motion.div>
        ) : (
          <motion.div
            key="phase2"
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.5 }}
            className="text-center z-10"
          >
            <motion.div
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2 }}
              className="mb-8"
            >
              <div className="text-[11px] text-accent font-medium tracking-wider uppercase mb-2">Matching Complete</div>
              <div className="text-xl font-bold text-white">최적의 전문가를 찾았습니다!</div>
            </motion.div>

            <div className="flex items-end justify-center gap-6">
              {top3.map((result, i) => (
                <motion.div
                  key={result.expert.id}
                  initial={{ opacity: 0, y: 30 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.3 + i * 0.12, duration: 0.4 }}
                  className={`${i === 0 ? 'w-36 -mt-4' : 'w-32'} bg-gradient-to-b ${RANK_COLORS[i]} border rounded-xl p-5 text-center backdrop-blur-sm relative`}
                >
                  <div className="text-2xl mb-2">{RANK_BADGES[i]}</div>
                  <div className="w-12 h-12 bg-gray-700/50 rounded-full mx-auto mb-2 flex items-center justify-center text-xl">
                    👤
                  </div>
                  <div className={`${i === 0 ? 'text-2xl' : 'text-xl'} font-bold text-white mb-1`}>
                    {result.score}%
                  </div>
                  <div className="text-[12px] text-gray-200 font-medium">{result.expert.name}</div>
                  <div className="text-[10px] text-gray-400 mt-0.5">
                    {result.expert.specialties[0]} · {result.expert.experienceYears}년
                  </div>
                </motion.div>
              ))}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
