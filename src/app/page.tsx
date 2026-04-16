'use client';

import { useState, useCallback } from 'react';
import { MatchConditions, MatchResult } from '@/data/types';
import { calculateMatches, calculateFunnel } from '@/data/matching';
import Header from '@/components/Header';
import StepIndicator from '@/components/StepIndicator';
import Step1Conditions from '@/components/Step1Conditions';
import MatchingTransition from '@/components/MatchingTransition';
import Step2Comparison from '@/components/Step2Comparison';
import Step3Confirmation from '@/components/Step3Confirmation';

type Step = 1 | 'transition' | 2 | 3;

const defaultConditions: MatchConditions = {
  sourceLang: '',
  targetLang: '',
  specialty: '',
  documentType: '',
  urgency: 'normal',
  certifications: [],
  minExperience: 0,
  preferNative: false,
  ndaRequired: false,
  notes: '',
};

export default function Home() {
  const [step, setStep] = useState<Step>(1);
  const [conditions, setConditions] = useState<MatchConditions>(defaultConditions);
  const [matchResults, setMatchResults] = useState<MatchResult[]>([]);
  const [selectedExpert, setSelectedExpert] = useState<MatchResult | null>(null);

  const funnel = calculateFunnel(conditions);
  const matchCount = funnel[funnel.length - 1].count;

  const handleStartMatching = useCallback(() => {
    const results = calculateMatches(conditions);
    setMatchResults(results);
    setStep('transition');
  }, [conditions]);

  const handleTransitionComplete = useCallback(() => {
    setStep(2);
  }, []);

  const handleSelectExpert = useCallback((result: MatchResult) => {
    setSelectedExpert(result);
  }, []);

  const handleConfirm = useCallback(() => {
    setStep(3);
  }, []);

  const handleReset = useCallback(() => {
    setStep(1);
    setConditions(defaultConditions);
    setMatchResults([]);
    setSelectedExpert(null);
  }, []);

  return (
    <div className="flex flex-col h-full">
      <Header />
      <StepIndicator currentStep={step} />
      <main className="flex-1 overflow-hidden">
        {step === 1 && (
          <Step1Conditions
            conditions={conditions}
            onChange={setConditions}
            onStartMatching={handleStartMatching}
          />
        )}
        {step === 'transition' && (
          <MatchingTransition
            results={matchResults.slice(0, 5)}
            matchCount={matchCount}
            onComplete={handleTransitionComplete}
          />
        )}
        {step === 2 && (
          <Step2Comparison
            conditions={conditions}
            results={matchResults.slice(0, 3)}
            selectedExpert={selectedExpert}
            onSelectExpert={handleSelectExpert}
            onConfirm={handleConfirm}
            onBack={() => setStep(1)}
          />
        )}
        {step === 3 && selectedExpert && (
          <Step3Confirmation
            conditions={conditions}
            selectedExpert={selectedExpert}
            onReset={handleReset}
          />
        )}
      </main>
    </div>
  );
}
