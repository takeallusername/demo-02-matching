'use client';

type Step = 1 | 'transition' | 2 | 3;

interface Props {
  currentStep: Step;
}

const STEPS = [
  { id: 1, label: '조건 입력' },
  { id: 'transition' as const, label: 'AI 매칭' },
  { id: 2, label: '전문가 선택' },
  { id: 3, label: '확정' },
];

function getStatus(stepId: (typeof STEPS)[number]['id'], currentStep: Step) {
  const order: Step[] = [1, 'transition', 2, 3];
  const currentIdx = order.indexOf(currentStep);
  const stepIdx = order.indexOf(stepId as Step);
  if (stepIdx < currentIdx) return 'completed';
  if (stepIdx === currentIdx) return 'active';
  return 'pending';
}

export default function StepIndicator({ currentStep }: Props) {
  return (
    <div className="bg-white border-b border-border px-6 py-2.5 flex items-center justify-center shrink-0">
      <div className="flex items-center gap-0">
        {STEPS.map((step, i) => {
          const status = getStatus(step.id, currentStep);
          return (
            <div key={step.label} className="flex items-center">
              <div className="flex items-center gap-2">
                <div
                  className={`w-5 h-5 rounded-full flex items-center justify-center text-[10px] font-bold transition-all duration-300 ${
                    status === 'completed'
                      ? 'bg-accent text-white'
                      : status === 'active'
                      ? 'bg-accent text-white animate-[pulse-glow_2s_ease-in-out_infinite]'
                      : 'bg-gray-200 text-gray-400'
                  }`}
                >
                  {status === 'completed' ? (
                    <svg className="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={3}>
                      <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
                    </svg>
                  ) : (
                    i + 1
                  )}
                </div>
                <span
                  className={`text-[12px] font-medium transition-colors duration-300 ${
                    status === 'active'
                      ? 'text-accent'
                      : status === 'completed'
                      ? 'text-text-primary'
                      : 'text-text-muted'
                  }`}
                >
                  {step.label}
                </span>
              </div>
              {i < STEPS.length - 1 && (
                <div
                  className={`w-16 h-px mx-3 transition-colors duration-300 ${
                    getStatus(STEPS[i + 1].id, currentStep) !== 'pending'
                      ? 'bg-accent'
                      : 'bg-gray-200'
                  }`}
                />
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}
