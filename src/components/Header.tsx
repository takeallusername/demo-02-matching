'use client';

export default function Header() {
  return (
    <header className="bg-navy-900 text-white h-12 flex items-center px-6 shrink-0 z-50">
      <div className="flex items-center gap-2.5">
        <div className="w-7 h-7 bg-accent rounded-lg flex items-center justify-center text-xs font-bold tracking-tight">
          HT
        </div>
        <span className="font-semibold text-[14px] tracking-tight">HuTrans AI</span>
        <span className="text-[11px] text-gray-400 ml-1">Beta</span>
      </div>
      <div className="ml-auto flex items-center gap-5 text-[12px] text-gray-400">
        <span className="text-gray-300 font-medium">번역 전문가 매칭</span>
        <span className="w-px h-4 bg-gray-700" />
        <span>Demo v2.0</span>
      </div>
    </header>
  );
}
