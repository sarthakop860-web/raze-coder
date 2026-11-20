export type Profile={id:string;display_name:string|null;role:"visitor"|"admin";created_at:string};
export type EventCategory={id:string;name:string;slug:string;description?:string|null};
export type FestivalEvent={id:string;category_id:string|null;category?:EventCategory|null;title:string;slug:string;description:string|null;event_date:string|null;start_time:string|null;end_time:string|null;venue:string|null;image_path:string|null;registration_url:string|null;is_published:boolean;created_at:string};
export type FAQ={id:string;question:string;answer:string;category:string|null;sort_order:number;is_published:boolean};
export type ScheduleItem={id:string;event_id:string;starts_at:string|null;ends_at:string|null;venue:string|null;event?:FestivalEvent};
